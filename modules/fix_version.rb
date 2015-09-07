module Arisa
  # Adds missing fix versions to issues
  class FixVersionModule
    def initialize(core, dispatcher)
      @core = core
      dispatcher.query_modules << self
    end

    def query(client)
      query = QUERIES[:fixversion]
      options = {
        max_results: JQL_RESULTS_DFL,
        fields: [:project]
      }

      client.Issue.jql(query, options).each { |issue| process issue }
    end

    def transition_data(project)
      @core.versions.refresh(VERSION_CACHE_TTL_ACTIVE)
      latest = @core.versions.latest(project)
      return unless latest
      {
        update: {
          fixVersions: [
            { add: { id: latest.id } }
          ]
        }
      }
    end

    def process(issue)
      issue.log :info, 'Adding missing fix version'
      data = transition_data(issue.project)
      unless data
        Client.log :error, "#{issue.project.key}: Latest version not found"
        return
      end
      issue.transition('Update Issue', data)
    end
  end
end
