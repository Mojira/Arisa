require 'net/http'

module Arisa
  # Caches the latest Java version
  class JavaVersion
    include Comparable

    attr_reader :identifier
    attr_reader :vendor

    def initialize(identifier, vendor = nil)
      @identifier = identifier
      @vendor = vendor
    end

    def release
      identifier.split('_').first
    end

    def outdated?
      return false if JRE_OUTDATED_IGNORE_VENDORS.include? vendor
      Gem::Version.new(release) < Gem::Version.new(latest.release)
    end

    def <=>(other)
      compared = Gem::Version.new(release) <=> Gem::Version.new(other.release)
      return compared unless compared.zero?
      identifier <=> other.identifier
    end

    def self.parse(subject)
      match = JRE_VERSION_REGEXP.match subject
      return unless match
      new(*match.captures[0..1])
    end

    # Expected output format: 1.2.3_45
    def self.latest(ttl = JRE_CACHE_TTL)
      return @latest if @cached && ttl && @cached + ttl > Time.now
      uri = URI.parse JRE_VERSION_URL
      response = Net::HTTP.get_response(uri).body.strip
      @cached = Time.now
      @latest = new(response)
    end
  end
end
