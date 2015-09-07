module JIRA
  module Resource
    # Add transitioning methods to the Issue class
    class Issue
      def transition(name, data = {})
        transition = Arisa::Transition.get(client, self, name)
        return false unless transition
        data[:transition] = {
          id: transition.id
        }
        transitions.build.save(data)
      end
    end
  end
end
