module Arisa
  # Remove or replace invalid labels on issues
  class LabelModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:labels]
    end

    def fancify(str)
      # The moderators have voted for the use of dashes
      # instead of underscores in a poll on May 3, 2015.
      label = str.gsub('_', '-')
      label.downcase! if label.include?('-') || label == label.capitalize
      label
    end

    def valid?(label)
      return false unless label =~ VALID_LABEL_REGEXP
      return false if LABEL_BLACKLIST.include? label.downcase
      return false if LABEL_BLACKLIST_REGEXP.any? { |exp| label =~ exp }
      true
    end

    def merge_issue_data(actions)
      {
        update: {
          labels: actions
        }
      }
    end

    def actions(label)
      fancy = fancify label
      return [{ remove: label }] unless valid?(fancy)
      return [{ remove: label }, { add: fancy }] unless label == fancy
      []
    end

    def issue_data(labels)
      return unless labels
      actions = labels.map { |label| actions(label) }.flatten
      merge_issue_data(actions) unless actions.empty?
    end

    def process(_, issue)
      data = issue_data(issue.labels)
      return unless data
      puts "#{issue.key}: Updating labels"
      issue.save!(data)
    end
  end
end
