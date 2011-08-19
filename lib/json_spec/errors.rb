module JsonSpec
  class MissingPathError < StandardError
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def to_s
      %(Missing JSON path "#{path}")
    end
  end

  class MissingDirectoryError < StandardError
    def to_s
      "No JsonSpec.directory set"
    end
  end

  class MissingFileError < StandardError
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def to_s
      "No JSON file at #{path}"
    end
  end
end
