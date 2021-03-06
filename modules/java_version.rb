module Arisa
  # Informs users about outdated Java versions
  class JavaVersionModule
    def initialize(_, dispatcher)
      dispatcher.crash_modules << self
    end

    def outdated?(reports)
      versions = reports.map do |report|
        JavaVersion.parse report.java_version
      end.compact
      !versions.empty? && versions.all?(&:outdated?)
    end

    def response(os)
      type = case os
             when /linux/i   then 'linux'   # Awesome!
             when /windows/i then 'windows' # Uh-oh...
             when /mac os/i  then 'osx'     # I'm sorry.
             else                 'generic' # Huh?
      end
      Response.new('generic', 'java_outdated', type)
    end

    def comment_on(issue, reports)
      report = reports.first
      os = report.data.traverse(:system, :operating_system)
      body = response(os).body
      comment = Comment.new(issue, body)
      return if comment.exist?
      issue.log :info, 'Creating comment about outdated Java version'
      comment.save
    end

    def process(_, issue, reports)
      return if issue.resolution
      comment_on(issue, reports) if outdated? reports
    end
  end
end
