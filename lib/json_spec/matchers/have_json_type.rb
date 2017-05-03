module JsonSpec
  module Matchers
    class HaveJsonType
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(type)
        @classes = type_to_classes(type)
        @path = nil
      end

      def matches?(json)
        @ruby = parse_json(json, @path)
        @classes.any? { |c| c === @ruby }
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        message_with_path("Expected JSON value type to be #{@classes.join(", ")}, got #{@ruby.class}")
      end
      alias :failure_message_for_should :failure_message

      def failure_message_when_negated
        message_with_path("Expected JSON value type to not be #{@classes.join(", ")}, got #{@ruby.class}")
      end
      alias :failure_message_for_should_not :failure_message_when_negated

      def description
        message_with_path(%(have JSON type "#{@classes.join(", ")}"))
      end

      private
        def type_to_classes(type)
          case type
          when Class then [type]
          when Array then type.map { |t| type_to_classes(t) }.flatten
          else
            case type.to_s.downcase
            when "boolean"     then [TrueClass, FalseClass]
            when "object"      then [Hash]
            when "nil", "null" then [NilClass]
            else [Module.const_get(type.to_s.capitalize)]
            end
          end
        end
    end
  end
end
