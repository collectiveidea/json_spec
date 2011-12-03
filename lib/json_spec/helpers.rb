require 'multi_json'

module JsonSpec
  module Helpers
    extend self

    def parse_json(json, path = nil)
      ruby = MultiJson.decode(%([#{json}])).first
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
    
    def load_json(relative_file_path)
      missing_directory! if JsonSpec.directory.nil?
      path = File.join(JsonSpec.directory, relative_file_path)
      missing_json_file!(path) unless File.exist?(path)
      File.read(path)
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
      
      def missing_directory!
        raise JsonSpec::MissingDirectoryError
      end
      
      def missing_json_file!(path)
        raise JsonSpec::MissingFileError.new(path)
      end
  end
end
