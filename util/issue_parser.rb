module Arisa
  # Retrieves certain elements like crash reports from
  # multiple fields and merges the output into an array
  class IssueParser
    attr_reader :issue

    def self.fields
      [:attachment, :comment, :description, :reporter]
    end

    def initialize(issue)
      @issue = issue
    end

    def reports_attachments
      reports = []
      issue.attachments.each do |attachment|
        reports.push(*reports_attachment(attachment))
      end
      reports
    end

    def reports_attachment(attachment)
      return unless attachment.mimeType == 'text/plain'
      return unless attachment.author.name == issue.reporter.name
      CrashReport.parse(issue.client.get(attachment.content).body)
    end

    def reports_description
      CrashReport.parse(issue.description)
    end

    def reports_comments
      reports = []
      issue.comments.each do |comment|
        reports.push(*reports_comment(comment))
      end
      reports
    end

    def reports_comment(comment)
      return unless comment.author && issue.reporter
      return unless comment.author['name'] == issue.reporter.name
      CrashReport.parse(comment.body)
    end

    def reports
      reports_attachments.push(*reports_description, *reports_comments)
    end
  end
end
