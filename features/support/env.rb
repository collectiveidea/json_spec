$: << File.expand_path("../../../lib", __FILE__)
require "json_spec/cucumber"

def last_json
  @last_json.to_s
end
