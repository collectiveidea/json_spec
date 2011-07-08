module JsonSpec
  module Helpers
    extend self

    def json_at_path(json, path)
      pretty_json_value(ruby_at_json_path(json, path))
    end

    def pretty_json_value(ruby)
      case ruby
      when Hash, Array then JSON.pretty_generate(ruby)
      when NilClass then "null"
      else ruby.inspect
      end
    end

    def ruby_at_json_path(json, path)
      json_path_to_keys(path).inject(parse_json_value(json)) do |value, key|
        case value
        when Hash, Array then value.fetch(key){ missing_json_path!(path) }
        else missing_json_path!(path)
        end
      end
    end

    def json_path_to_keys(path)
      path.to_s.gsub(/(?:^\/|\/$)/, "").split("/").map{|k| k =~ /^\d+$/ ? k.to_i : k }
    end

    def parse_json_value(json)
      JSON.parse(%({"root":#{json}}))["root"]
    rescue JSON::ParserError
      # Re-raise more appropriate parsing error
      JSON.parse(json)
    end

    def missing_json_path!(path)
      raise JsonSpec::MissingPathError.new(path)
    end
  end
end
