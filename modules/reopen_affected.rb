module Arisa
  # Reopens issues that are marked as affecting
  # at least one of their fix versions
  class ReopenAffectedModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:resolution, 'fixVersions', :versions]
    end

    def affected?(issue)
      fix_versions = issue.fields['fixVersions']
      return unless fix_versions
      version_ids = issue.versions.map(&:id)
      fix_version_ids = fix_versions.map { |version| version['id'] }
      !(version_ids & fix_version_ids).empty?
    end

    def process(_, issue)
      return unless issue.resolution
      return unless affected?(issue)
      issue.log :info, 'Reopening issue affecting a fix version'
      issue.transition 'Reopen Issue'
    end
  end
end
