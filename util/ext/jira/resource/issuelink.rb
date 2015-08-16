module JIRA
  # Add issue links to JIRA::Resource
  module Resource
    IssueLinkType = Class.new(JIRA::BaseFactory)
    IssueLinkTypeFactory = Class.new(JIRA::BaseFactory)
    IssueLinkFactory = Class.new(JIRA::BaseFactory)

    # Represents a link between two issues
    class IssueLink < JIRA::Base
      has_one :type, class: JIRA::Resource::IssueLinkType
      has_one :inwardIssue, class: JIRA::Resource::Issue
      has_one :outwardIssue, class: JIRA::Resource::Issue

      nested_collections true

      def self.endpoint_name
        'issueLink'
      end
    end
  end

  # Add the methods to the JIRA client
  class Client
    def IssueLink
      JIRA::Resource::IssueLinkFactory.new(self)
    end

    def IssueLinkType
      JIRA::Resource::IssueLinkTypeFactory.new(self)
    end
  end
end
