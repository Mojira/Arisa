require_relative 'snippet'

module Arisa
  # Retrieves comment templates for the bot
  class Response < Snippet
    def initialize(*path)
      super('responses', *path)
    end

    def body(add_footer = true)
      response = super
      response << footer if add_footer
      response
    end

    def footer
      "\n" + self.class.new('footer').body(false) % COMMENT_FOOTER_ARGS
    end
  end
end
