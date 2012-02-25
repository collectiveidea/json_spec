module JsonSpec
  module Messages
    def message_with_path(message)
      message << %( at path "#{@path}") if @path
      message
    end
  end
end
