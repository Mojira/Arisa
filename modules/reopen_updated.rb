require 'time'

module Arisa
  # Reopens issues that are resolved as "Awaiting Response"
  # when they are updated after the issue was resolved.
  class ReopenUpdatedModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:resolution, :resolutiondate, :updated]
    end

    def updated?(issue)
      return unless issue.resolution
      return unless issue.resolution['name'] == 'Awaiting Response'
      resolved = issue.fields['resolutiondate']
      updated = issue.fields['updated']
      return unless resolved && updated
      Time.parse(updated) > Time.parse(resolved) + 30
    end

    def process(_, issue)
      return unless updated?(issue)
      return unless Guidelines.complete?(issue)
      puts "#{issue.key}: Reopening updated issue"
      issue.transition 'Reopen Issue'
    end
  end
end
