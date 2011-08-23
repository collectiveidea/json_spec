$: << File.expand_path("../../../lib", __FILE__)
require "json_spec/cucumber"

JsonSpec.directory = File.expand_path("../files", __FILE__)

def last_json
  @last_json.to_s
end
