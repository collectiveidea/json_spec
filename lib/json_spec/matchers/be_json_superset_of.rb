module JsonSpec
  module Matchers
    class BeJsonSupersetOf
      include JsonSpec::Helpers
      include JsonSpec::Exclusion
      include JsonSpec::Messages

      def initialize(expected_json = nil)
        @expected_json = expected_json
      end

      def matches?(actual_json)
        raise "Expected JSON not provided" if @expected_json.nil?

        actual = exclude_keys(parse_json(actual_json, @path))
        expected = exclude_keys(parse_json(@expected_json))

        raise "Expected JSON objects" unless actual.is_a?(Hash) && expected.is_a?(Hash)

        actual_slice = expected.keys.each_with_object(Hash.new) { |k, hash|
          hash[k] = actual[k] if actual.include? k
        }

        scrub(actual_slice) == scrub(expected)
      end

      def at_path(path)
        @path = path
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
        message_with_path("Expected 'actual' to be a superset of 'expected' JSON")
      end

      def failure_message_for_should_not
        message_with_path("Expected 'actual' to not be a superset of 'expected' JSON")
      end

      def description
        message_with_path("be superset of JSON")
      end

      def to_file(path)
        @expected_json = load_json(path)
        self
      end

      private
      def scrub(obj)
        generate_normalized_json(obj).chomp + "\n"
      end
    end
  end
end
