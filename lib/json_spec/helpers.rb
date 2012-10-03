require "multi_json"

module JsonSpec
  module Helpers
    extend self

    def parse_json(json, path = nil)
      ruby = MultiJson.decode("[#{json}]").first
      value_at_json_path(ruby, path)
    rescue MultiJson::DecodeError
      MultiJson.decode(json)
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

    def load_json(relative_path)
      missing_json_directory! if JsonSpec.directory.nil?
      path = File.join(JsonSpec.directory, relative_path)
      missing_json_file!(path) unless File.exist?(path)
      File.read(path)
    end

    private
      def value_at_json_path(ruby, path)
        return ruby unless path

        path.split("/").inject(ruby) do |value, key|
          case value
          when Hash
            value.fetch(key){ missing_json_path!(path) }
          when Array
            missing_json_path!(path) unless key =~ /^\d+$/
            value.fetch(key.to_i){ missing_json_path!(path) }
          else
            missing_json_path!(path)
          end
        end
      end

      def missing_json_path!(path)
        raise JsonSpec::MissingPath.new(path)
      end

      def missing_json_directory!
        raise JsonSpec::MissingDirectory
      end

      def missing_json_file!(path)
        raise JsonSpec::MissingFile.new(path)
      end
  end
end
