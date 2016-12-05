module JsonSpec
  module Matchers
    class HaveJsonFields
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(fields)
        @fields = fields
      end

      def matches?(json)
        @data = parse_json(json, @path)
        return false unless @data.is_a?(Hash)
        !@fields.map{|f| @data.has_key?(f)}.include?(false)
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message_with_path("Expected JSON to contain all of the following fields #{@fields.join(", ")}")
      end

      def failure_message_for_should_not
        message_with_path("Expected JSON to not contain any of the following fields #{@fields.join(", ")}")
      end

      def description
        message_with_path(%(have JSON fields "#{@fields.join(", ")}"))
      end
    end
  end
end
