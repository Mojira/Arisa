module Arisa
  # Contains utility methods for transitioning issues
  class Transition
    def self.all(client, issue)
      client.Transition.all(issue: issue)
    end

    def self.get(client, issue, name)
      match = all(client, issue).find { |transition| transition.name == name }
      unless match
        $stderr.puts "#{issue.key}: Transition '#{name}' is not available"
      end
      match
    end
  end
end
