module Arisa
  # Parser for command line arguments
  class Arguments
    attr_reader :quiet
    attr_reader :verbose

    def initialize(arguments)
      arguments.each { |argument| parse(argument) }
    end

    def parse(argument)
      case argument
      when '-h', '--help'    then help
      when '-q', '--quiet'   then @quiet   = true
      when '-v', '--verbose' then @verbose = true
      else error(argument)
      end
    end

    def error(argument)
      $stderr.puts "#{$PROGRAM_NAME}: unrecognized option '#{argument}'"
      $stderr.puts "Try '#{$PROGRAM_NAME} --help' for more information."
      exit 1
    end

    def help
      puts <<EOF
Usage: #{$PROGRAM_NAME} [OPTION]...
Run the bot with the specified command line arguments

      --help     display this help and exit
      --quiet    suppress all normal output
      --verbose  enable more detailed output
EOF
      exit
    end
  end
end
