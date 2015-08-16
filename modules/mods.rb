module Arisa
  # Resolves issues with crash reports from modded clients as invalid
  class ModsModule
    def initialize(_, dispatcher)
      dispatcher.crash_modules << self
    end

    def modded?(reports)
      reports.delete_if { |report| report.modtype.nil? }
      !reports.empty? && reports.all?(&:modded?)
    end

    def resolve(issue)
      puts "#{issue.key}: Resolving issue from modified client"
      issue.transition 'Resolve Issue', transition_data
    end

    def transition_data
      response = Response.new('invalid', 'modded')
      {
        update: { comment: [add: { body: response.body }] },
        fields: { resolution: { name: 'Invalid' } }
      }
    end

    def process(_, issue, reports)
      resolve issue if modded? reports
    end
  end
end
