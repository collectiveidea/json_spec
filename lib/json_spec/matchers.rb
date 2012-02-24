require "json"
require "rspec"

module JsonSpec
  module Matchers
    class BeJsonEql
      include JsonSpec::Helpers
      include JsonSpec::Exclusion

      attr_reader :expected, :actual

      def diffable?
        true
      end

      def initialize(expected_json)
        @expected_json = expected_json
      end

      def matches?(actual_json)
        @actual, @expected = scrub(actual_json, @path), scrub(@expected_json)
        @actual == @expected
      end

      def at_path(path)
        @path = path
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
        message = "Expected equivalent JSON"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected inequivalent JSON"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = "equal JSON"
        message << %( at path "#{@path}") if @path
        message
      end

      private
        def scrub(json, path = nil)
          generate_normalized_json(exclude_keys(parse_json(json, path))).chomp + "\n"
        end
    end

    class IncludeJson
      include JsonSpec::Helpers
      include JsonSpec::Exclusion

      def initialize(expected_json)
        @expected_json = expected_json
      end

      def matches?(actual_json)
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

    class HaveJsonPath
      include JsonSpec::Helpers

      def initialize(path)
        @path = path
      end

      def matches?(json)
        begin
          parse_json(json, @path)
          true
        rescue JsonSpec::MissingPathError
          false
        end
      end

      def failure_message_for_should
        %(Expected JSON path "#{@path}")
      end

      def failure_message_for_should_not
        %(Expected no JSON path "#{@path}")
      end

      def description
        %(have JSON path "#{@path}")
      end
    end

    class HaveJsonType
      include JsonSpec::Helpers

      def initialize(klass)
        @klass = klass
      end

      def matches?(json)
        @ruby = parse_json(json, @path)
        @ruby.is_a?(@klass)
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message = "Expected JSON value type to be #{@klass}, got #{@ruby.class}"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected JSON value type to not be #{@klass}, got #{@ruby.class}"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = %(have JSON type "#{@klass.to_s}")
        message << %( at path "#{@path}") if @path
        message
      end
    end

    class HaveJsonSize
      include JsonSpec::Helpers

      def initialize(size)
        @expected = size
      end

      def matches?(json)
        ruby = parse_json(json, @path)
        @actual = ruby.is_a?(Enumerable) ? ruby.size : 1
        @actual == @expected
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message_for_should
        message = "Expected JSON value size to be #{@expected}, got #{@actual}"
        message << %( at path "#{@path}") if @path
        message
      end

      def failure_message_for_should_not
        message = "Expected JSON value size to not be #{@expected}, got #{@actual}"
        message << %( at path "#{@path}") if @path
        message
      end

      def description
        message = %(have JSON size "#{@expected}")
        message << %( at path "#{@path}") if @path
        message
      end
    end

    def be_json_eql(json)
      JsonSpec::Matchers::BeJsonEql.new(json)
    end

    def include_json(json)
      JsonSpec::Matchers::IncludeJson.new(json)
    end

    def have_json_path(path)
      JsonSpec::Matchers::HaveJsonPath.new(path)
    end

    def have_json_type(klass)
      JsonSpec::Matchers::HaveJsonType.new(klass)
    end

    def have_json_size(size)
      JsonSpec::Matchers::HaveJsonSize.new(size)
    end
  end
end

RSpec.configure do |config|
  config.include JsonSpec::Matchers
end
