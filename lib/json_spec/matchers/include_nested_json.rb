module JsonSpec
  module Matchers
    class IncludeNestedJson < IncludeJson

      def matches?(actual_json)
        raise "Expected included JSON not provided" if @expected_json.nil?
        actual = parse_json(actual_json)
        matches_nested?(actual)
      end

      def matches_nested?(parsed_json)
        case parsed_json
        when Hash then parsed_json.values.map{|v| exclude_keys(v) }.include?(expected) || test_contained_enumerables(parsed_json)
        when Array then parsed_json.map{|e| exclude_keys(e) }.include?(expected)       || test_contained_enumerables(parsed_json)
        when String then parsed_json.include?(expected)
        else false
        end
      end

      def test_contained_enumerables(parsed_json)
        case parsed_json
        when Hash then parsed_json.values.reduce(false) {|accum, value| accum || test_if_nests(value)}
        when Array then parsed_json.reduce(false) {|accum, value| accum || test_if_nests(value)}
        else false
        end
      end

      def test_if_nests(value)
        value.respond_to?(:each) && matches_nested?(value)
      end

      def expected
        @expected ||= exclude_keys(parse_json(@expected_json))
      end

      def failure_message_for_should
        message_with_path("Expected 'actual' to include nested 'expected' JSON")
      end

      def failure_message_for_should_not
        message_with_path("Expected 'actual' to not include nested 'expected' JSON")
      end

      undef at_path
    end
  end
end
