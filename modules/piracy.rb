module Arisa
  # Remove or replace invalid labels on issues
  class LabelModule
    def initialize(_, dispatcher)
      dispatcher.issue_modules << self
    end

    def fields
      [:environment]
    end

    def pirated?(issue)
      environment = issue.environment
      PIRACY_IDENTIFIERS.any? { |identifier| environment.include? identifier }
    end

    def transition_data
      response = Response.new('invalid', 'pirated')
      {
        update: { comment: [add: { body: response.body }] },
        fields: { resolution: { name: 'Invalid' } }
      }
    end

    def process(_, issue)
      return unless pirated?(issue)
      puts "#{issue.key}: Resolving issue with pirated software"
      issue.transition 'Resolve Issue', transition_data
    end
  end
end
