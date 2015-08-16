#!/bin/ruby

require 'jira'

# Require all source files
core_dir = File.dirname(__FILE__)
files = File.join(core_dir, '**', '*.rb')
Dir[files].each { |file| require file }

# Arisa project module
module Arisa
  # Stores the JIRA client and starts the main loop
  class Core
    attr_reader :client
    attr_reader :dispatcher
    attr_reader :versions

    def initialize
      @client = JIRA::Client.new(CLIENT_OPTIONS)
      @dispatcher = Dispatcher.new(self)
      @versions = Versions.new(@client)
    end

    def start
      loop do
        @dispatcher.dispatch
        sleep @dispatcher.task_delay
      end
    end
  end

  Core.new.start
end
