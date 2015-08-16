module Arisa
  class ReopenAffectedModule
    def self.execute_tasks(client)
      query = 'fixVersion = latestReleasedVersion() AND' \
          ' affectedVersion = latestReleasedVersion() AND status NOT IN (Open, Reopened)'
      options = {
        max_results: 25
      }

      client.Issue.jql(query, options).each do |issue|
        next if Util.issue_incomplete(issue)
        puts "#{issue.key}: Reopening issue affecting a fix version"
        Util.reopen_issue(client, issue, {})
      end
    end
  end
end
