module JsonSpec
  module Matchers
    class IncludeJson
      include JsonSpec::Helpers
      include JsonSpec::Exclusion
      include JsonSpec::Messages

      def initialize(expected_json = nil)
        @expected_json = expected_json
        @path = nil
      end

      def matches?(actual_json)
        raise "Expected included JSON not provided" if @expected_json.nil?

        @actual_json = actual_json

        actual = parse_json(actual_json, @path)
        expected = exclude_keys(parse_json(@expected_json))
        case actual
        when Hash then actual.values.map { |v| exclude_keys(v) }.include?(expected)
        when Array then actual.map { |e| exclude_keys(e) }.include?(expected)
        when String then actual.include?(expected)
        else false
        end
      end

      def at_path(path)
        @path = path
        self
      end

      def from_file(path)
        @expected_json = load_json(path)
        self
      end

      def excluding(*keys)
        excluded_keys.merge(keys.map(&:to_s))
        self
      end

      def including(*keys)
        excluded_keys.subtract(keys.map(&:to_s))
        self
      end

      def failure_message
        message_with_path("Expected #{@actual_json} to include #{@expected_json}")
      end
      alias :failure_message_for_should :failure_message

      def failure_message_when_negated
        message_with_path("Expected #{@actual_json} to not include #{@expected_json}")
      end
      alias :failure_message_for_should_not :failure_message_when_negated

      def description
        message_with_path("include JSON")
      end
    end
  end
end
