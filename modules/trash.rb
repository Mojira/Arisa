module Arisa
  # Resolves issues in the TRASH project
  class TrashModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:project, :status]
    end

    def process(_, issue)
      return unless issue.project.name == 'Trash'
      return if issue.resolution
      issue.log :info, 'Resolving issue in TRASH'
      issue.transition 'Resolve Issue'
    end
  end
end
