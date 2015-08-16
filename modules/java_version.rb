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
      Response.new('invalid', 'java_outdated', type)
    end

    def comment_on(issue)
      os = report.data.traverse(:system, :operating_system)
      body = response(os).body
      comment = Comment.new(issue, body)
      return unless comment.exist?
      puts "#{issue.key}: Creating comment about outdated Java version"
      comment.save
    end

    def process(_, issue, reports)
      comment_on issue if outdated? reports
    end
  end
end
