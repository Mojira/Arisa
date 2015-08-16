module Arisa
  class PiracyModule
    def self.execute_tasks(client)
      identifiers = '"\"Bootstrap 0\" OR \"Launcher: 1.0.10  (bootstrap 4)\" OR \"Launcher: 1.0.10  (bootstrap 5)\" OR \"Launcher 2.0\" OR \"Launcher 3.0.0\" OR \"Launcher: 3.1.0\" OR \"Launcher: 3.1.1\" OR \"Launcher: 3.1.4\" OR \"1.0.8\" OR \"uuid sessionId\" OR \"auth_access_token\" OR \"windows-${arch}\" OR  \"keicraft\" OR \"keinett\" OR \"nodus\" OR \"iridium\" OR \"mcdonalds\" OR \"uranium\" OR \"nova\" OR \"divinity\" OR \"gemini\" OR \"mineshafter\""'
      query = "project in (MC, MCL) AND status = Open AND (description ~ #{identifiers} OR environment ~ #{identifiers})"
      options = {
        max_results: 25
      }

      client.Issue.jql(query, options).each do |issue|
        transition_data = {
          fields: {
            resolution: {
              name: 'Invalid'
            }
          }
        }

        puts "#{issue.key}: Resolving issue involving pirated software"
        Util.resolve_issue_template(client, issue, transition_data, File.join('invalid', 'pirated'))
      end
    end
  end
end
