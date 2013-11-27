module JsonSpec
  module Matchers
    class HaveJsonKeys
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(keys)
        @keys = keys
      end

      def matches?(actual_json)
        @actual_json = actual_json
        @data = parse_json(actual_json, @path)
        return false unless @data.is_a?(Hash)
        @keys.all?{|key| @data.has_key?(key.to_s)}
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message_with_path("Expected #{@actual_json} to contain all of the following keys #{@keys.join(", ")}")
      end

      def failure_message_for_should_not
        message_with_path("Expected #{@actual_json} to not contain any of the following keys #{@keys.join(", ")}")
      end

      def description
        message_with_path(%(have JSON keys "#{@keys.join(", ")}"))
      end
    end
  end
end
