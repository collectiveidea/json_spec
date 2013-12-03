module JsonSpec
  module Matchers
    class IncludeJson
      include JsonSpec::AtPath
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
        when Hash then actual.values.map{|v| exclude_keys(v) }.include?(expected)
        when Array then actual.map{|e| exclude_keys(e) }.include?(expected)
        when String then actual.include?(expected)
        else false
        end
      end

      def from_file(path)
        @expected_json = load_json(path)
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
