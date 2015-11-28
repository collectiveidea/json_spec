$LOAD_PATH << ::File.expand_path('../../lib', __FILE__)

require "minitest/autorun"
require "minitest/matchers"
require "json_spec"

# Give OpenStruct support for to_json
require "ostruct"

class OpenStruct
  def to_json *args
    table.to_json *args
  end
end
