require 'time'

module Arisa
  # Retrieves a list of issues to be processed from the server.
  # This class stores the last returned per-project issue id,
  # as not all IDs are incremental across different projects.
  class IssuePool
    attr_reader :client
    attr_reader :dispatcher
    attr_reader :issues
    attr_reader :last_ids
    attr_reader :timestamp

    def self.fields
      [:project]
    end

    def initialize(dispatcher)
      @client = dispatcher.core.client
      @dispatcher = dispatcher
      @issues = []
      @last_ids = {}
    end

    def initialize_time
      return true if @timestamp
      options = { max_results: JQL_RESULTS_MIN }
      issue = client.Issue.jql('ORDER BY created DESC', options).first
      return unless issue
      puts "Starting with issue #{issue.key} (ID #{issue.id})"
      @timestamp = Time.parse(issue.created)
    end

    def initialize_time!
      return true if initialize_time
      fail 'failed to retrieve last issue creation time'
    end

    def query_timestamp
      timestamp.getlocal.strftime(JQL_TIME_FORMAT)
    end

    def query
      initialize_time!
      query = "created >= '#{query_timestamp}' ORDER BY created ASC"
      options = {
        fields: dispatcher.fields,
        max_results: JQL_RESULTS_MAX
      }
      client.Issue.jql(query, options).each do |result|
        @issues << result if should_process result
      end
    end

    def should_process(issue)
      issue_id = Integer(issue.id)
      project_id = Integer(issue.project.id)
      return if @last_ids[project_id] && issue_id <= @last_ids[project_id]
      @last_ids[project_id] = issue_id
      true
    end

    def retrieve
      result = @issues.dup
      @issues.clear
      result
    end

    def empty?
      @issues.empty?
    end
  end
end
