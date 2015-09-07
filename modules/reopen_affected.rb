module Arisa
  # Reopens issues that are marked as affecting
  # a version that's newer than any fix version
  class ReopenAffectedModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:resolution, :fixVersions, :versions]
    end

    def affected?(issue)
      return unless issue.fields['fixVersions']
      fix_versions = issue.fixVersions.reject(&:archived)
      issue.versions.reject(&:archived).each do |version|
        fix_versions.each do |fix_version|
          diff = version <=> fix_version
          next unless diff
          return true unless diff < 0
        end
      end
      false
    end

    def process(_, issue)
      return unless issue.resolution
      return unless affected?(issue)
      issue.log :info, 'Reopening issue affecting a fix version'
      issue.transition 'Reopen Issue'
    end
  end
end
