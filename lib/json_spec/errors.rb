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
      %(No file directory set using JsonSpec.directory)
    end
  end
  
  class MissingFileError < StandardError
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def to_s
      %(Missing JSON file "#{path}")
    end
  end
end
