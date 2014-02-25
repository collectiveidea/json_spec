require "json_spec/matchers/be_json_eql"
require "json_spec/matchers/include_json"
require "json_spec/matchers/have_json_path"
require "json_spec/matchers/have_json_type"
require "json_spec/matchers/have_json_size"

module JsonSpec
  module Matchers
    def be_json_eql(json = nil)
      JsonSpec::Matchers::BeJsonEql.new(json)
    end

    def include_json(json = nil)
      JsonSpec::Matchers::IncludeJson.new(json)
    end

    def have_json_path(path)
      JsonSpec::Matchers::HaveJsonPath.new(path)
    end

    def have_json_type(type)
      JsonSpec::Matchers::HaveJsonType.new(type)
    end

    def have_json_size(size)
      JsonSpec::Matchers::HaveJsonSize.new(size)
    end

    def self.included base
      if base.respond_to? :register_matcher
        instance_methods.each do |name|
          base.register_matcher name, name
        end
      end
    end
  end
end

if defined?(RSpec)
  RSpec.configure do |config|
    config.include JsonSpec::Matchers
  end
end
