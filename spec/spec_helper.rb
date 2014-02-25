require "json_spec"

RSpec.configure do |config|
  config.before do
    JsonSpec.reset
  end

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

def files_path
  File.expand_path("../support/files", __FILE__)
end
