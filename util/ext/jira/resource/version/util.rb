require 'date'

module JIRA
  module Resource
    # Represents a project version
    # This class patches JIRA::Resource::Version to provide additional
    # functionality for comparison and checking the type and release
    # status of the version.
    class Version
      include Comparable

      def create_name
        @version_name = Arisa::VersionName.new(self) unless @version_name
        @version_name
      end

      def released?
        return released unless VERSION_UNRELEASED_REGEXP
        name !~ VERSION_UNRELEASED_REGEXP
      end

      def type
        return :release if version_name.release
        return :snapshot if version_name.snapshot
      end

      def version_name
        create_name
      end

      def <=>(other)
        s_date = attrs['releaseDate']
        o_date = other.attrs['releaseDate']
        return version_name <=> other.version_name unless s_date && o_date
        Date.parse(s_date) <=> Date.parse(o_date)
      end
    end
  end
end
