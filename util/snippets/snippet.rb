module Arisa
  # Reads text snippets from files
  class Snippet
    attr_reader :type
    attr_reader :path

    def base
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', @type))
    end

    def initialize(type, *path)
      @type = type
      @path = File.expand_path(File.join(base, *path))
    end

    def body(*)
      File.read(@path) if valid!
    end

    def exist?
      File.exist?(@path) if valid!
    end

    def valid?
      @path.start_with?(base + File::SEPARATOR)
    end

    def valid!
      return true if valid?
      fail SecurityError, 'untrusted directory', caller
    end

    def to_s
      body
    end
  end
end
