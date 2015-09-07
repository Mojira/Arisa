module Arisa
  # Calls the modules and controls the main program flow
  class Dispatcher
    attr_reader :core, :fields, :modules, :issue_pool
    attr_reader :crash_modules, :issue_modules, :updtd_modules, :query_modules

    def initialize(core)
      initialize_arrays
      @core = core
      @task_delay = 0
      @issue_pool = IssuePool.new(self)
      @fields = IssuePool.fields | IssueParser.fields
      ENABLED_MODULES.each { |new_class| register_module(new_class) }
      register_fields
    end

    def initialize_arrays
      @modules = []
      @crash_modules = []
      @issue_modules = []
      @updtd_modules = []
      @query_modules = []
    end

    def register_module(new_class)
      new_module = new_class.new(core, self)
      modules << new_module
      rescue => e; handle e
    end

    def register_fields
      (issue_modules | updtd_modules).each do |subject|
        next unless subject.respond_to? :fields
        fields.push(*subject.fields)
      end
    end

    def handle(e)
      return handle_http_error e if e.is_a? JIRA::HTTPError
      log e
    end

    def log(e)
      details = (e.message + "\n" + e.backtrace.join("\n"))
      File.open('crash.log', 'a') { |f| f.write(details + "\n\n") }
      Core.log :error, details
    end

    def dispatch
      client = core.client
      query_modules.each { |target| target.query(client) }
      process_issues(client)
      rescue => e; handle e
    end

    def process_issues(client)
      issue_pool.query
      issue_pool.eat(:created).each { |issue| process_created(client, issue) }
      issue_pool.eat(:updated).each do |issue|
        process_updated(client, issue)
        process_crash_reports(client, issue)
      end
    end

    def process_created(client, issue)
      issue.log :verbose, 'Processing created issue'
      issue_modules.each { |target| target.process(client, issue) }
    end

    def process_updated(client, issue)
      issue.log :verbose, 'Processing updated issue'
      updtd_modules.each { |target| target.process(client, issue) }
    end

    def process_crash_reports(client, issue)
      reports = IssueParser.new(issue).reports
      return if reports.empty?
      crash_modules.each { |target| target.process(client, issue, reports.dup) }
    end

    def handle_http_error(e)
      code = Integer(e.response.code)
      $stderr.puts "HTTP Error #{code} (#{e.message})"
      $stderr.puts 'Please check your login credentials' if code == 401
      $stderr.puts nil, e.backtrace
      if [401, 402, 407, 505].include? code
        $stderr.puts nil, 'Stopping the bot'
        exit false
      end
      check_cooldown(code)
    end

    def check_cooldown(code)
      return unless code == 429
      @task_delay += EMERGENCY_ADD_DELAY
      puts "HTTP 429 received, delay increased to #{task_delay} seconds"
      puts "Enabling cooldown for #{EMERGENCY_COOLDOWN} seconds"
      sleep EMERGENCY_COOLDOWN
    end

    def task_delay
      TASK_DELAY + @task_delay
    end
  end
end
