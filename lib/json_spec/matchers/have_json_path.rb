module JsonSpec
  module Matchers
    class HaveJsonPath
      include JsonSpec::Helpers

      def initialize(path)
        @path = path
      end

      def matches?(json)
        parse_json(json, @path)
        true
      rescue JsonSpec::MissingPath
        false
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
  end
end
