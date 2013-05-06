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
        case actual
        when Hash then match_hash(actual, expected)
        when Array then match_array(actual, expected)
        when String then match_string(actual, expected)
        else false
        end
      end


      def match_hash(actual, expected)
        actual.values.map{|v| exclude_keys(v) }.include?(expected)
      end

      def match_array(actual, expected)
        actual.map{|e| match_hash(e, expected) if e.is_a?(Hash)}.include?(true) ||
        actual.map{|e| e }.include?(expected)
      end

      def match_string(actual, expected)
        actual.include?(expected)
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
