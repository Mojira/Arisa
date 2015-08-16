module Arisa
  # Stores project versions and allows you
  # to group them by certain categories
  class Versions
    attr_reader :client
    attr_reader :cached
    attr_reader :versions

    def initialize(client)
      @client = client
      @versions = {}
    end

    def refresh(ttl = VERSION_CACHE_TTL_PASSIVE)
      return if @cached && ttl && @cached + ttl > Time.now
      @versions.clear
      client.Project.all.each do |project|
        refresh_project project
      end
      @cached = Time.now
    end

    def refresh_project(project)
      @versions[project.id] = project.versions.map { |v| Version.new(v) }
    end

    def all
      refresh
      @versions.values.flatten
    end

    def detect(name, project = nil)
      refresh
      versions = project ? @versions[project.id] : all
      return unless versions
      versions.detect { |version| version.version_name.extract == name }
    end

    def released
      refresh
      filter!(all, true)
    end

    def unreleased
      refresh
      filter!(all, false)
    end

    def filter!(versions, released = nil, type = nil)
      versions.select! { |v| released == v.released? } unless released.nil?
      versions.select! { |v| type == v.type } unless type.nil?
      versions
    end

    def latest(project, released = nil, type = nil)
      refresh
      project_versions = @versions[project.id]
      return unless project_versions
      filter!(project_versions, released, type).sort.last
    end
  end
end
