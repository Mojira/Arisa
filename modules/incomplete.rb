module Arisa
  # Resolves issues as incomplete if they do not contain enough details.
  # See Arisa::Guidelines (util/guidelines.rb) for more information.
  class IncompleteModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:attachment, :description, :environment, :resolution, :summary]
    end

    def match_launcher_crash(environment)
      return false unless environment
      environment =~ Regexp.new(
        'OS: .* (.*)[[:space:]]+' \
        'Java: .* (.*)[[:space:]]+' \
        'Launcher: .* (.*)[[:space:]]+' \
        'Minecraft: .* (.*)'
      )
    end

    def transition_data(issue)
      launcher_crash = match_launcher_crash(issue.fields['environment'])
      type = launcher_crash ? 'crash_report' : 'generic'
      response = Response.new('incomplete', type)
      {
        fields: { resolution: { name: 'Awaiting Response' } },
        update: { comment: [add: { body: response.body }] }
      }
    end

    def process(_, issue)
      return if issue.resolution
      return if Guidelines.complete?(issue)
      issue.log :info, 'Resolving incomplete issue'
      issue.transition 'Resolve Issue', transition_data(issue)
    end
  end
end
