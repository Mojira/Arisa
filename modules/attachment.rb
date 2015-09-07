module Arisa
  # Removes attachments with certain mime types or file names
  # (as specified in the configuration file) from issues.
  class AttachmentModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:attachment]
    end

    def process(_, issue)
      issue.attachments.each do |attachment|
        next if valid?(attachment)
        issue.log :info, "Deleting invalid attachment #{attachment.filename}"
        attachment.delete
      end
    end

    def valid?(attachment)
      mime_valid?(attachment.mimeType) && name_valid?(attachment.filename)
    end

    def mime_valid?(mime)
      !ATTACHMENT_DELETE_MIME.include? mime
    end

    def name_valid?(name)
      !ATTACHMENT_DELETE_NAME.any? { |exp| name =~ exp }
    end
  end
end
