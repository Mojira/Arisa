module Arisa
  # Removes unreleased versions from issues
  class UnreleasedModule
    def initialize(core, dispatcher)
      @core = core
      dispatcher.updtd_modules << self
    end

    def fields
      [:project, :versions]
    end

    def unreleased_ids(issue)
      unreleased = @core.versions.unreleased.map(&:id)
      issue.versions.map(&:id).select { |id| unreleased.include? id }
    end

    def issue_data(issue)
      ids = unreleased_ids(issue)
      return if ids.empty?
      response = Response.new('generic', 'affects_unreleased')
      data = {
        update: {
          comment: [add: { body: response.body }],
          versions: unreleased_ids(issue).map { |id| { remove: { id: id } } }
        }
      }
      add_latest(data, issue, ids)
    end

    def add_latest(data, issue, version_ids)
      if issue.versions.length == version_ids.length
        latest = @core.versions.latest(issue.project, true)
        return unless latest
        data[:update][:versions] << { add: { id: latest.id } }
      end
      data
    end

    def process(_, issue)
      return if unreleased_ids(issue).empty?
      @core.versions.refresh(VERSION_CACHE_TTL_ACTIVE)
      data = issue_data(issue)
      return unless data
      issue.log :info, 'Removing unreleased versions'
      issue.save(data)
    end
  end
end
