module Arisa
  class LabelModule
    @initialized = false

    @label_query = ''
    @labels_remove = %w(bad bug bugs ce error game help ios ipad iphone ipod mcce mcpe pc pe play scrolls)

    @labels_remove_match = [
      /android/i,
      /annoying/i,
      /creative/i,
      /feature/i,
      /galaxy/i,
      /glitch/i,
      /issue/i,
      /launcher/i,
      /minecraft/i,
      /mojang/i,
      /please/i,
      /problem/i,
      /stupid/i,
      /survival/i,
      /xperia/i,
      /\Anew/i,
      /\Anot/i,
      /\Apocket/i
    ]

    def self.initialize_plugin(_client)
      sanitized_labels = []

      @labels_remove.each do |label|
        sanitized_labels << label.dump
      end

      @label_query = sanitized_labels.join(',')
      @initialized = true
    end

    def self.labelify(str)
      res = str.gsub('_', '-')
      res.downcase! if res.include?('-') || res == res.capitalize
      res
    end

    def self.label_valid(label)
      return false unless label =~ %r{\A[0-9a-z/][a-z-]{,30}[0-9a-z]\z}i
      return false if Util.match_preview(label)
      return false if @labels_remove.include?(label.downcase)
      return false if @labels_remove_match.any? { |exp| label =~ exp }
      true
    end

    def self.execute_tasks(client)
      initialize_plugin(client) unless @initialized
      query = "labels in (#{@label_query}) OR updated > -10m ORDER BY created ASC"
      options = {
        max_results: 25
      }

      client.Issue.jql(query, options).each do |issue|
        issue_labels = issue.labels
        next unless issue_labels

        issue_data = {
          update: {
            labels: []
          }
        }

        update_required = false
        issue_labels.each do |issue_label|
          issue_label_labelified = labelify(issue_label)
          if !label_valid(issue_label_labelified)
            update_required = true
            issue_data[:update][:labels] << { remove: issue_label }
          elsif !issue_label == issue_label_labelified
            update_required = true
            issue_data[:update][:labels] << { remove: issue_label }
            issue_data[:update][:labels] << { add: issue_label_labelified }
          end
        end

        next unless update_required
        puts "#{issue.key}: Removing redundant labels"
        issue.save!(issue_data)
      end
    end
  end
end
