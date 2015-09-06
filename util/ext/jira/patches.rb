# Patch issues in the jira-ruby library
module JIRA
  module Resource
    # Patch the Issue class
    class Issue
      # Add missing fixVersions relationship
      has_many :fixVersions,
               class: JIRA::Resource::Version,
               nested_under: 'fields'
    end
  end
end
