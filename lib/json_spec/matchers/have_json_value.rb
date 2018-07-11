module JsonSpec
  module Matchers
    class HaveJsonValue
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(value)
        @value = value
      end

      def matches?(json)
        @ruby = parse_json(json, @path)
        @value == @ruby
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        message_with_path("Expected JSON value to be \"#{@value}\", got \"#{@ruby}\"")
      end
      alias :failure_message_for_should :failure_message

      def failure_message_when_negated
        message_with_path("Expected JSON value to not be \"#{@value}\", got \"#{@ruby}\"")
      end
      alias :failure_message_for_should_not :failure_message_when_negated

      def description
        message_with_path(%(have JSON value "#{@value}"))
      end
    end
  end
end
