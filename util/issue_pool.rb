require 'time'

module Arisa
  # Retrieves a list of issues to be processed from the server.
  # This class stores the last returned per-project issue id,
  # as not all IDs are incremental across different projects.
  class IssuePool
    attr_reader :client, :dispatcher
    attr_reader :issues, :updated_issues
    attr_reader :created, :updated
    attr_reader :last_ids

    def self.fields
      [:project, :created, :updated]
    end

    def initialize(dispatcher)
      @client = dispatcher.core.client
      @dispatcher = dispatcher
      @issues = []
      @updated_issues = []
      @last_ids = {}
    end

    def initialize_time
      return true if @created && @updated
      options = { max_results: JQL_RESULTS_MIN }
      issue = client.Issue.jql('ORDER BY created DESC', options).first
      return unless issue
      puts "Reading issue time from #{issue.key} (ID #{issue.id})"
      @created = Time.parse(issue.created)
      @updated = Time.parse(issue.updated)
    end

    def initialize_time!
      return true if initialize_time
      fail 'failed to retrieve last issue creation time'
    end

    def timestamp(date)
      date.getlocal.strftime(JQL_TIME_FORMAT)
    end

    def query
      initialize_time!
      query_created
      query_updated
    end

    def query_created
      query = "created >= '#{timestamp @created}' ORDER BY created ASC"
      options = {
        fields: dispatcher.fields,
        max_results: JQL_RESULTS_MAX
      }
      client.Issue.jql(query, options).each do |result|
        next unless should_process? result
        @issues << result
      end
    end

    def query_updated
      query = "updated >= '#{timestamp @updated}' ORDER BY updated ASC"
      options = {
        fields: dispatcher.fields,
        max_results: JQL_RESULTS_MAX
      }
      issues = client.Issue.jql(query, options)
      check_update_time(issues)
      @updated_issues |= issues
    end

    def should_process?(issue)
      issue_id = Integer(issue.id)
      project_id = Integer(issue.project.id)
      return if @last_ids[project_id] && issue_id <= @last_ids[project_id]
      @created = Time.parse(issue.created)
      @last_ids[project_id] = issue_id
      true
    end

    def check_update_time(issues)
      issues.each do |issue|
        time = Time.parse(issue.updated)
        @updated = time if time > @updated
      end
    end

    def eat(type = :created)
      subject = (type == :updated) ? @updated_issues : @issues
      result = subject.dup
      subject.clear
      result
    end
  end
end
