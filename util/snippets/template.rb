require_relative 'snippet'

module Arisa
  # Retrieves issue field templates
  # used when checking for incomplete issues
  class Template < Snippet
    def initialize(*path)
      super('templates', *path)
    end
  end
end
