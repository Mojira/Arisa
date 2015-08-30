module Arisa
  # Resolves duplicates of common parent tickets by
  # comparing the stack trace headers on crash reports
  class DuplicatesModule
    def initialize(_, dispatcher)
      dispatcher.crash_modules << self
    end

    def parent(report)
      PARENT_ISSUES.each do |parent, conditions|
        return parent if parent?(report, conditions)
      end
      nil
    end

    def parent?(report, conditions)
      stacktrace = report.stacktrace[:main]
      return unless stacktrace
      return unless check_description(report, conditions)
      return unless check_version(report, conditions)
      return unless check_header(stacktrace, conditions)
      return unless check_class(stacktrace, conditions)
      true
    end

    def check_description(report, conditions)
      description = report.data.traverse(:main, :description)
      check_condition conditions[:descriptions], description
    end

    def check_version(report, conditions)
      version = report.data.traverse(:system, :minecraft_version)
      check_condition conditions[:versions], version
    end

    def check_header(stacktrace, conditions)
      header = stacktrace.lines.first.strip
      check_condition conditions[:headers], header
    end

    def check_class(stacktrace, conditions)
      exception_class = stacktrace.lines.first.split(':').first.strip
      check_condition conditions[:classes], exception_class
    end

    def check_condition(options, value)
      return true unless options
      return unless value
      options.each do |option|
        return true if value == option
        return true if option.is_a?(Regexp) && value =~ option
      end
      false
    end

    def resolve(client, issue, parent)
      puts "#{issue.key}: Resolving duplicate of #{parent}"
      client.IssueLink.build.save link_data(issue.key, parent)
      issue.transition 'Resolve Issue', transition_data(issue.key, parent)
    end

    def link_data(issue_key, parent_key)
      {
        type:         { name: 'Duplicate' },
        inwardIssue:  {  key:  issue_key  },
        outwardIssue: {  key:  parent_key }
      }
    end

    def transition_data(_, parent_key)
      response = Response.new('duplicate', 'issue', parent_key)
      response = Response.new('duplicate', 'duplicate') unless response.exist?
      {
        update: { comment: [add: { body: response.body % parent_key }] },
        fields: { resolution: { name: 'Duplicate' } }
      }
    end

    def process(client, issue, reports)
      return if issue.resolution
      reports.each do |report|
        parent = parent(report)
        next unless parent
        return resolve(client, issue, parent)
      end
    end
  end
end
