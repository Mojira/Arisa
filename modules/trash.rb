module Arisa
  # Resolves issues in the TRASH project
  class TrashModule
    def initialize(core, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:project, :status]
    end

    def process(_, issue)
      return unless issue.project.name == 'Trash'
      return if issue.resolution
      puts "#{issue.key}: Resolving issue in TRASH"
      issue.transition('Resolve Issue')
    end
  end
end
