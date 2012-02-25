module JsonSpec
  class Error < StandardError
  end

  class MissingPath < Error
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def to_s
      %(Missing JSON path "#{path}")
    end
  end

  class MissingDirectory < Error
    def to_s
      "No JsonSpec.directory set"
    end
  end

  class MissingFile < Error
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def to_s
      "No JSON file at #{path}"
    end
  end
end
