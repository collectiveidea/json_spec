require "json_spec"

RSpec.configure do |config|
  config.before do
    JsonSpec.reset
  end
end

def files_path
  File.expand_path("../support/files", __FILE__)
end
