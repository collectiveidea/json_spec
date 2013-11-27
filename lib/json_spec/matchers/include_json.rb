module JsonSpec
  module Matchers
    class IncludeJson
      include JsonSpec::Helpers
      include JsonSpec::Exclusion
      include JsonSpec::Messages

      require 'hashdiff'

      attr_reader :expected, :actual

      def diffable?
        true
      end

      def initialize(expected_json = nil)
        @expected_json = expected_json
      end

      def matches?(actual_json)
        raise "Expected included JSON not provided" if @expected_json.nil?

        @actual_json = actual_json


        actual = parse_json(actual_json, @path)
        expected = parse_json(@expected_json)
        @actual = actual
        @expected = expected

        if actual.is_a?(Hash) && expected.is_a?(Hash)
          diff = HashDiff.diff(exclude_keys(expected), exclude_keys(actual))
          diff.each do |value|
            if value[0] == "-" || value[0] == "~"
              return false
            else
              true
            end
          end
        elsif actual.is_a?(Array)
          actual.map{|e| exclude_keys(e) }.include?(exclude_keys(expected))
        elsif actual.is_a?(String)
          actual.include?(exclude_keys(expected))
        elsif actual.is_a?(Hash)
          actual.values.map{|v| exclude_keys(v) }.include?(exclude_keys(expected))
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

      def failure_message_for_should
        message_with_path("Expected #{@expected_json} to be included in #{@actual_json}")
      end

      def failure_message_for_should_not
        message_with_path("Expected #{@expected_json} to be included in #{@actual_json}")
      end

      def description
        message_with_path("include JSON")
      end
    end
  end
end