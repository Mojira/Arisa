module Arisa
  # Adds missing security levels to issues
  class SecurityModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:project, :security]
    end

    def issue_data(security_id)
      {
        update: {
          security: [
            set: {
              id: security_id.to_s
            }
          ]
        }
      }
    end

    def process(_, issue)
      return if issue.fields['security']
      security_id = DEFAULT_SECURITY_LEVELS[issue.project.key]
      return unless security_id
      issue.log :info, 'Adding default security level'
      issue.save(issue_data(security_id))
    end
  end
end
