require "spec_helper"

describe JsonSpec::Matchers::IncludeNestedJson do

  describe "matching nested values" do
    json_strings = [
        %({"fname":"jolly", "lname":"roger", "partners": [{"fname": "dread pirate", "lname": "roberts"}]}),
        %({"fname":"jolly", "lname":"roger", "partner": {"fname": "dread pirate", "lname": "roberts"}}),
        %({"fname":"jolly", "lname":"roger", "connections": {"partners": [{"fname": "dread pirate", "lname": "roberts"}]}})
      ]

    it "matches values regardless of path depth" do
      json_strings.each do |json_string|
        json_string.should include_nested_json '{"fname": "dread pirate", "lname": "roberts"}'
      end
    end

    it "does not match value split across depths" do
      json_strings.each do |json_string|
        json_string.should_not include_nested_json '{"fname": "dread pirate", "lname": "roger"}'
      end
    end
  end
end
