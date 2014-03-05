module JsonSpec
  module AtPath
    extend self

    def at_path(path)
      @path = path
      self
    end
  end
end
