module Arisa
  class IncompleteResolveModule
    def self.match_launcher_crash(environment)
      return false unless environment
      environment =~ Regexp.new(
        'OS: .* (.*)[[:space:]]+' \
        'Java: .* (.*)[[:space:]]+' \
        'Launcher: .* (.*)[[:space:]]+' \
        'Minecraft: .* (.*)'
      )
    end

    def self.execute_tasks(client)
      query = 'created > -10m AND status = Open AND project NOT IN (STAFF, MCTEST)'
      options = {
        max_results: 1_000_000,
        fields: [
          :attachment,
          :description,
          :environment,
          :summary
        ]
      }

      client.Issue.jql(query, options).each do |issue|
        transition_data = {
          fields: {
            resolution: {
              name: 'Awaiting Response'
            }
          }
        }

        next if Guidelines.complete?(issue)
        puts "#{issue.key}: Resolving incomplete issue"
        Util.resolve_issue_template(
          client,
          issue,
          transition_data,
          File.join(
            'incomplete',
            match_launcher_crash(issue.environment) ? 'crash_report' : 'generic'
          )
        )
      end
    end
  end
end
