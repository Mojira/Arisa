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
      # The Mojira moderators voted for the use of dashes
      # instead of underscores in a poll on May 03, 2015.
      label = str.gsub '_', '-'
      label.downcase! if label.include?('-') || label == label.capitalize
      label = find_alias label
      label = find_known label
      label
    end

    def find_known(label)
      KNOWN_LABELS.find { |known_label| similar?(label, known_label) } || label
    end

    def normalize(label)
      label.downcase.delete '_-'
    end

    def find_alias(label)
      match = LABEL_ALIASES.find { |old, _| similar?(label, old) }
      return match[1] if match
      label
    end

    def similar?(l1, l2)
      (normalize l1) == (normalize l2)
    end

    def valid?(label)
      return false unless label =~ VALID_LABEL_REGEXP
      return false if LABEL_BLACKLIST.any? { |exp| similar?(label, exp) }
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
      issue.log :info, 'Updating labels'
      issue.save(data)
    end
  end
end
