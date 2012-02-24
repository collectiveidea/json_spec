module JsonSpec
  module Matchers
    class IncludeJson
      include JsonSpec::Helpers
      include JsonSpec::Exclusion

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
        excluded_keys.merge(keys.map{|k| k.to_s })
        self
      end

      def including(*keys)
        excluded_keys.subtract(keys.map{|k| k.to_s })
        self
      end

      def failure_message_for_should
        message = "Expected included JSON"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected excluded JSON"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = "include JSON"
        message << %( at path "#{@path}") if @path
        message
      end
    end
  end
end
