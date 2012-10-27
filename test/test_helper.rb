require "minitest/autorun"
require "minitest/matchers"
require "json_spec"

# Make JsonSpec avaialble in tests
class MiniTest::Unit::TestCase
  include JsonSpec::Matchers
end

# Give OpenStruct support for to_json
require "ostruct"

class OpenStruct
  def to_json *args
    table.to_json *args
  end
end
