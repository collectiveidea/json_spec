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

        actual = exclude_keys(parse_json(actual_json, @path))
        expected = exclude_keys(parse_json(@expected_json))
        included_in_json?( actual, expected )
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

      private
      def included_in_json?( actual, expected )
        case actual
          when Hash then included_in_hash?(actual, expected) or actual.values.any?{ |v| included_in_json?(v, expected) }
          when Array then included_in_array?(actual, expected)
          else actual == expected
        end
      end

      def included_in_array?( actual_array, expected)
        if expected.is_a? Array
          (expected - actual_array).empty?
        else
          actual_array.include? expected
        end
      end

      def included_in_hash?( actual_hash, expected )
        return false unless expected.is_a? Hash
        expected == actual_hash.select{|k,_| expected.has_key? k}
      end

    end
  end
end
