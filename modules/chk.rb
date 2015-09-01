require 'time'

module Arisa
  # Adds missing CHK values to issues
  class CHKModule
    attr_reader :field

    def initialize(core, dispatcher)
      dispatcher.query_modules << self if fetch_field(core.client)
    end

    def fetch_field(client)
      match = client.Field.all.find { |field| field.name == 'CHK' }
      unless match
        Core.log :error, "CHK field not found, disabling #{self.class.name}"
        return
      end
      @field = match.id
    end

    def query(client)
      query = QUERIES[:chk]
      options = {
        max_results: JQL_RESULTS_DFL
      }

      client.Issue.jql(query, options).each { |issue| update_chk(issue) }
    end

    def update_chk(issue)
      transition_data = {
        fields: {
          @field => Time.now.strftime(API_TIME_FORMAT)
        }
      }

      issue.log :info, 'Setting missing CHK value'
      issue.transition 'Update Issue', transition_data
    end
  end
end
