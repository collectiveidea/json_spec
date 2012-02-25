module JsonSpec
  module Matchers
    class BeJsonEql
      include JsonSpec::Helpers
      include JsonSpec::Exclusion
      include JsonSpec::Messages

      attr_reader :expected, :actual

      def diffable?
        true
      end

      def initialize(expected_json = nil)
        @expected_json = expected_json
      end

      def matches?(actual_json)
        raise "Expected equivalent JSON not provided" if @expected_json.nil?

        @actual, @expected = scrub(actual_json, @path), scrub(@expected_json)
        @actual == @expected
      end

      def at_path(path)
        @path = path
        self
      end

      def to_file(path)
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
        message_with_path("Expected equivalent JSON")
      end

      def failure_message_for_should_not
        message_with_path("Expected inequivalent JSON")
      end

      def description
        message_with_path("equal JSON")
      end

      private
        def scrub(json, path = nil)
          generate_normalized_json(exclude_keys(parse_json(json, path))).chomp + "\n"
        end
    end
  end
end
