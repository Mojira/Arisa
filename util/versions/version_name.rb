module Arisa
  # Represents a project version
  class VersionName
    include Comparable

    attr_reader :version
    attr_reader :name

    def initialize(version)
      @version = version
      @name = version.name
    end

    def <=>(other)
      s_snapshot = snapshot
      o_snapshot = other.snapshot
      return s_snapshot <=> o_snapshot if s_snapshot && o_snapshot

      s_release = release
      o_release = other.release
      return unless s_release && o_release
      Gem::Version.new(s_release) <=> Gem::Version.new(o_release)
    end

    def release
      return if snapshot
      return unless name.scan(/[[[:digit:]]\.]+/).length == 1
      match = (name.match Gem::Version::VERSION_PATTERN)[0]
      match if match && match.include?('.')
    end

    def snapshot
      name.match(/\b[0-9]{2}w[0-9]{2}[a-z]\b/)
    end

    def extract
      release || snapshot
    end

    def valid?
      !extract.nil?
    end
  end
end
