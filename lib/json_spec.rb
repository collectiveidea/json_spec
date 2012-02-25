require "json"
require "rspec"
require "json_spec/errors"
require "json_spec/configuration"
require "json_spec/exclusion"
require "json_spec/helpers"
require "json_spec/messages"
require "json_spec/matchers"
require "json_spec/memory"

module JsonSpec
  extend Configuration
  extend Memory
end
