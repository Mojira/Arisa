module Arisa
  # Parses and stores Minecraft crash reports
  class CrashReport
    attr_reader :data
    attr_reader :stacktrace

    def initialize(report)
      @data = {}
      @stacktrace = {}
      @section = :main
      @mode = :value
      parse report
    end

    def parse(text)
      text.each_line { |line| parse_line(line.squish) }
    end

    def parse_line(line)
      return if line.start_with? CR_COMMENT_PREFIX
      return if update_section(line) || update_mode(line)

      if @mode == :value
        parse_value_line line
      elsif @mode == :stacktrace
        parse_stacktrace_line line
      end
    end

    def parse_value_line(line)
      pair = line.split(CR_VALUE_SEPARATOR, 2)
      return false unless pair.length == 2
      key = pair[0].symbolify.to_sym
      @data[@section] ||= {}
      @data[@section][key] = pair[1].strip
    end

    def parse_stacktrace_line(line)
      @stacktrace[@section] ||= ''
      @stacktrace[@section] << line + "\n"
    end

    def update_section(line)
      return false unless line =~ /\A-- [[:alpha:][:blank:]]+ --\z/
      match = CR_SECTIONS.find { |_, sct| line == "-- #{sct[:title]} --" }
      @section = match ? match[0] : :main
      @mode = :value
      true
    end

    def update_mode(line)
      type = CR_SECTIONS.traverse(@section, :stacktrace)
      if line.empty?
        @mode = parse_block_stacktrace(type) ? :stacktrace : :value
        return true
      end
      update_header_mode(line, type)
    end

    def update_header_mode(line, stacktrace)
      if line == CR_STACKTRACE_HEADER && stacktrace == :value
        @mode = :stacktrace
        return true
      elsif line == CR_DETAILS_HEADER
        @mode = :value
        return true
      end
      false
    end

    def parse_block_stacktrace(type)
      return false unless type == :block
      @data[@section] && !@stacktrace[@section]
    end

    def modtype
      data.traverse(:system, :is_modded)
    end

    def version
      data.traverse(:system, :minecraft_version)
    end

    def java_version
      data.traverse(:system, :java_version)
    end

    def modded?
      CR_MODDED.any? { |exp| modtype =~ exp }
    end

    def self.parse(text)
      reports = []
      return reports unless text && text.include?(CR_HEADER)
      text.split(CR_HEADER).each do |report_text|
        report = new(report_text.strip)
        reports << report unless report.data.empty?
      end
      reports
    end
  end
end
