module JIRA
  module Resource
    # Add logging methods to the Issue class
    class Issue
      def log(level, text)
        Arisa::Core.log(level, "#{key}: #{text}")
      end
    end
  end
end
