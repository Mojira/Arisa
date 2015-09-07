module Arisa
  # Class for manipulation of issue comments
  class Comment
    attr_accessor :issue
    attr_accessor :body

    def initialize(issue, body)
      @issue = issue
      @body = body
    end

    def build
      @issue.comments.build
    end

    def save
      build.save(body: @body)
    end

    def exist?
      return false unless @issue
      squished = @body.squish
      comments = issue.comments
      comments && comments.any? { |comment| squished == comment.body.squish }
    end
  end
end
