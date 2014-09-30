module JsonSpec
  module Matchers
    class HaveJsonSize
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(size)
        @expected = size
      end

      def matches?(json)
        ruby = parse_json(json, @path)
        if ruby.nil?
          @actual = 0
        else
          @actual = Enumerable === ruby ? ruby.size : 1
        end
        @actual == @expected
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        message_with_path("Expected JSON value size to be #{@expected}, got #{@actual}")
      end
      alias :failure_message_for_should :failure_message

      def failure_message_when_negated
        message_with_path("Expected JSON value size to not be #{@expected}, got #{@actual}")
      end
      alias :failure_message_for_should_not :failure_message_when_negated

      def description
        message_with_path(%(have JSON size "#{@expected}"))
      end
    end
  end
end
