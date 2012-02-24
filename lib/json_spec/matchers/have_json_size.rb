module JsonSpec
  module Matchers
    class HaveJsonSize
      include JsonSpec::Helpers

      def initialize(size)
        @expected = size
      end

      def matches?(json)
        ruby = parse_json(json, @path)
        @actual = Enumerable === ruby ? ruby.size : 1
        @actual == @expected
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message = "Expected JSON value size to be #{@expected}, got #{@actual}"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected JSON value size to not be #{@expected}, got #{@actual}"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = %(have JSON size "#{@expected}")
        message << %( at path "#{@path}") if @path
        message
      end
    end
  end
end
