module Arisa
  # Resolves issues with crash reports from archived versions
  class VersionModule
    def initialize(core, dispatcher)
      @core = core
      dispatcher.crash_modules << self
    end

    def outdated?(issue, reports)
      versions = reports.map(&:version).compact
      !versions.empty? && versions.all? do |version_name|
        version = @core.versions.detect(version_name, issue.project)
        version && version.original.archived
      end
    end

    def resolve(issue)
      puts "#{issue.key}: Resolving issue with outdated crash reports"
      issue.transition 'Resolve Issue', transition_data
    end

    def transition_data
      response = Response.new('invalid', 'outdated')
      {
        update: { comment: [add: { body: response.body }] },
        fields: { resolution: { name: 'Invalid' } }
      }
    end

    def process(_, issue, reports)
      resolve issue if outdated?(issue, reports)
    end
  end
end
