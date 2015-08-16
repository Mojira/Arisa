module Arisa
  class TrashResolveModule
    def self.execute_tasks(client)
      query = 'project = Trash AND (status = Open OR resolution = Unresolved)'
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

        puts "#{issue.key}: Resolving trashed issue"
        Util.resolve_issue(client, issue, transition_data)
      end
    end
  end
end
