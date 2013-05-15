module JsonSpec
  module Matchers
    class IncludeJson
      include JsonSpec::Helpers
      include JsonSpec::Exclusion
      include JsonSpec::Messages

      def initialize(expected_json = nil)
        @expected_json = expected_json
      end

      def matches?(actual_json)
        raise "Expected included JSON not provided" if @expected_json.nil?

        actual = parse_json(actual_json, @path)
        expected = exclude_keys(parse_json(@expected_json))

        if matching_hash_values?(actual, expected)
          matching_hash_values(actual, expected)
        elsif matching_mixed_array?(actual)
          matching_mixed_array(actual, expected)
        else
          RSpec::Matchers::BuiltIn::Include.new(expected).matches?(actual)
        end
      end

      def matching_mixed_array?(actual)
        actual.is_a?(Array) && actual.any?{|e| e.is_a?(Hash)}
      end

      def matching_mixed_array(actual, expected)
        actual.any?{|e| matching_hash_values(e, expected)} ||
        actual.map{|e| exclude_keys(e) }.include?(expected)
      end

      def matching_hash_values?(actual, expected)
        (actual.is_a?(Hash) && !expected.is_a?(Hash)) ||
        (actual.is_a?(Hash) && actual.values.any?{|v| v.is_a?(Hash)})
      end

      def matching_hash_values(actual, expected)
        actual.values.map{|v| exclude_keys(v) }.include?(expected)
      end

      def matching_array?(actual)
        actual.is_a?(Array)
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

      def failure_message_for_should
        message_with_path("Expected included JSON")
      end

      def failure_message_for_should_not
        message_with_path("Expected excluded JSON")
      end

      def description
        message_with_path("include JSON")
      end
    end
  end
end
