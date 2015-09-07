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
        diff = compare_unique_dates(s_date, o_date)
        return diff if diff
        version_name <=> other.version_name
      end

      def compare_unique_dates(s_date, o_date)
        return unless s_date && o_date
        diff = Date.parse(s_date) <=> Date.parse(o_date)
        # Multiple versions released on the
        # same date aren't always identical.
        # We'll compare the names instead.
        diff unless diff == 0
      end
    end
  end
end
