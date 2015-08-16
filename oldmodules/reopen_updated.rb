module Arisa
  class ReopenUpdatedModule
    def self.execute_tasks(client)
      query = 'resolution = "Awaiting Response" AND resolved < -15m AND updated > -15m'
      options = {
        max_results: 1_000_000
      }

      client.Issue.jql(query, options).each do |issue|
        next if Util.issue_incomplete(issue)
        puts "#{issue.key}: Reopening updated issue"
        Util.reopen_issue(client, issue, {})
      end
    end
  end
end

# TODO: Only if updated by reporter
