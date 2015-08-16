require 'date'

module Arisa
  # Represents a project version
  # This class can be initialized using a normal JIRA::Resource::Version
  # and provides additional functionality for comparison and checking the
  # type and release status of the version. You can convert the object
  # back to a normal JIRA::Resource::Version by calling #original.
  class Version
    include Comparable

    attr_reader :original
    attr_reader :version_name

    def initialize(original)
      @original = original
      @version_name = VersionName.new(original)
    end

    def released?
      return original.released unless VERSION_UNRELEASED_REGEXP
      original.name !~ VERSION_UNRELEASED_REGEXP
    end

    def type
      return :release if version_name.release
      return :snapshot if version_name.snapshot
    end

    def <=>(other)
      s_date = original.attrs['releaseDate']
      o_date = other.original.attrs['releaseDate']
      return version_name <=> other.version_name unless s_date && o_date
      Date.parse(s_date) <=> Date.parse(o_date)
    end
  end
end
