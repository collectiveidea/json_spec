module JsonSpec
  module Matchers
    class HaveJsonPath
      include JsonSpec::Helpers

      def initialize(path)
        @path = path
      end

      def matches?(json)
        obj = parse_json(json, @path)
        if @content
          return false unless @content.eql?(obj)
        end
        true
      rescue JsonSpec::MissingPath
        false
      end

      def with_content(content)
        @content = content
        self
      end

      def failure_message_for_should
        message = %(Expected JSON path "#{@path}")
        message += %( with content "#{@content}") if @content
        message
      end

      def failure_message_for_should_not
        message = %(Expected no JSON path "#{@path}")
        message += %( with content "#{@content}") if @content
        message
      end

      def description
        message = %(have JSON path "#{@path}")
        message += %( with content "#{@content}") if @content
        message
      end
    end
  end
end
