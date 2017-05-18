module JsonSpec
  module Matchers
    class BeOneOf
      include JsonSpec::Helpers
      include JsonSpec::Messages

      def initialize(*expected_jsons)
        @expected_jsons = expected_jsons
      end

      def matches?(actual_json)
        @actual = normalize_json(actual_json, @path)

        @expected_jsons
        .map {|json| BeJsonEql.new(json).at_path(@path) }
        .map {|matcher| matcher.matches?(actual_json) }
        .any?
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message_with_path("Expected JSON value to be one of #{@expected_jsons}, got #{@actual.inspect}")
      end

      def failure_message_for_should_not
        failure_message_for_should.sub(/to be one of/, "not to be one of")
      end

      def description
        message_with_path("is one of #{@expected_jsons}")
      end
    end
  end
end
