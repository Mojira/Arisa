module Arisa
  # Resolves issues in the TRASH project
  class TrashModule
    def initialize(_, dispatcher)
      dispatcher.updtd_modules << self
    end

    def fields
      [:project, :status, :resolution]
    end

    def process(_, issue)
      return if issue.resolution
      return unless issue.project.name == 'Trash'
      issue.log :info, 'Resolving issue in TRASH'
      issue.transition 'Resolve Issue'
    end
  end
end
