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
end
