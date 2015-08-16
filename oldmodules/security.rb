module Arisa
  class SecurityModule
    def self.get_security_id(key)
      case key
      when 'MC', 'MCPE'
        return '10317'
      when 'MCAPI'
        return '10314'
      when 'MCL'
        return '10503'
      when 'SC'
        return '10603'
      when 'TRASH'
        return '10309'
      else
        return null
      end
    end

    def self.execute_tasks(client)
      query = 'level is EMPTY AND project in (MC, MCPE, MCAPI, MCL, SC, TRASH)'
      options = {
        max_results: 25
      }

      client.Issue.jql(query, options).each do |issue|
        security_id = get_security_id(issue.project.key)
        next unless security_id

        issue_data = {
          update: {
            security: [
              set: {
                id: security_id
              }
            ]
          }
        }

        puts "#{issue.key}: Adding missing security level"
        issue.save!(issue_data)
      end
    end
  end
end
