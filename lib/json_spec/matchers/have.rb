module JsonSpec
  module Matchers
    class Have
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(path, type)
        @path = path.to_s
        @class = extract_class(path, type)
      end

      def matches?(json)
        begin
          @value = parse_json(json, @path)
        rescue JsonSpec::MissingPath
          false
        end
        @value.class <= @class
      end

      def failure_message_for_should
        message_with_path("Expected JSON value type to be #{@class}, got #{@value.class}")
      end

      def failure_message_for_should_not
        message_with_path("Expected JSON value type to not be #{@class}, got #{@value.class}")
      end

      def description
        message_with_path(%(have JSON type "#{@class}"))
      end

      private
        def extract_class(path, type)
          if type.class == String and type.empty?
            class_name = path.class
            class_name = Integer if class_name == Symbol
          else
            class_name = type
          end

          class_name
        end
    end
  end
end
