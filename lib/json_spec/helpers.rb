module JsonSpec
  module Helpers
    extend self

    def parse_json(json, path = nil)
      ruby = JSON.parse(%([#{json}])).first
      value_at_json_path(ruby, path)
    rescue JSON::ParserError
      JSON.parse(json)
    end

    def normalize_json(json, path = nil)
      ruby = parse_json(json, path)
      generate_normalized_json(ruby)
    end

    def generate_normalized_json(ruby)
      case ruby
      when Hash, Array then JSON.pretty_generate(ruby)
      else ruby.to_json
      end
    end

    private
      def value_at_json_path(ruby, path)
        return ruby unless path

        json_path_to_keys(path).inject(ruby) do |value, key|
          case value
          when Hash, Array then value.fetch(key){ missing_json_path!(path) }
          else missing_json_path!(path)
          end
        end
      end

      def json_path_to_keys(path)
        path.split("/").map{|k| k =~ /^\d+$/ ? k.to_i : k }
      end

      def missing_json_path!(path)
        raise JsonSpec::MissingPathError.new(path)
      end
  end
end
