module Arisa
  # Provides methods for checking issues against
  # the guidelines for reporting issues
  class Guidelines
    def self.template?(field, content)
      Template.new(field).body.squish == content.squish
    end

    def self.field_valid?(fields, field, min = 1)
      content = fields[field]
      return false unless length_valid?(content, min)
      return false if template?(field, content)
      true
    end

    def self.length_valid?(content, min = 1, max = nil)
      return unless content
      length = content.length

      return false if min && length < min
      return false if max && length > max
      true
    end

    def self.any_field_valid?(fields)
      return true if field_valid?(fields, 'description', 30)
      return true if field_valid?(fields, 'environment', 200)
      false
    end

    def self.any_length_valid?(fields)
      return true if length_valid?(fields['summary'], 60)
      return true if length_valid?(fields['attachments'])
      false
    end

    def self.complete?(issue)
      fields = issue.fields
      any_field_valid?(fields) || any_length_valid?(fields)
    end
  end
end
