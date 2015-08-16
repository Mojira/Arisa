module Arisa
  class VersionModule
    def self.execute_tasks(client)
      Util.version_refresh(client)
      version_query = Util.future_versions.map { |f| f.id.dump }.join(',')

      query = "affectedVersion in (#{version_query})"
      options = {
        max_results: 25,
        fields: [
          :comment,
          :project,
          :versions
        ]
      }

      client.Issue.jql(query, options).each do |issue|
        Util.version_refresh(client, 60)

        issue_versions = issue.versions
        next unless issue_versions

        future_version_ids = []
        issue_version_ids = []

        Util.future_versions.each { |v| future_version_ids << v.id }
        issue_versions.each { |v| issue_version_ids << v.id }

        remove_version_ids = future_version_ids & issue_version_ids
        next if remove_version_ids.empty?

        issue_data = {
          update: {
            versions: []
          }
        }

        if issue_version_ids.length == remove_version_ids.length
          latest_release = Util.latest_release(issue.project)
          latest_preview = Util.latest_preview(issue.project)
          latest_published = Util.version_compare(latest_release, latest_preview)
          next unless latest_published

          latest_published_id = latest_published.id
          next unless latest_published_id

          issue_data[:update][:versions] << { add: { id: latest_published_id } }
        end

        remove_version_ids.each do |remove_version_id|
          issue_data[:update][:versions] << { remove: { id: remove_version_id } }
        end

        puts "#{issue.key}: Removing unreleased versions"
        issue.save!(issue_data)

        Util.issue_comment_template(issue, File.join('generic', 'affects_unreleased'))
      end
    end
  end
end
