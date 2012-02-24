module JsonSpec
  module Matchers
    class HaveJsonType
      include JsonSpec::Helpers

      def initialize(klass)
        @klass = klass
      end

      def matches?(json)
        @ruby = parse_json(json, @path)
        @ruby.is_a?(@klass)
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message = "Expected JSON value type to be #{@klass}, got #{@ruby.class}"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected JSON value type to not be #{@klass}, got #{@ruby.class}"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = %(have JSON type "#{@klass}")
        message << %( at path "#{@path}") if @path
        message
      end
    end
  end
end
