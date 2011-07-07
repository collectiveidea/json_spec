World(JsonSpec::Helpers)

Then /^the (?:JSON|json)(?: response)? should have "(.*)"$/ do |path|
  last_json.should have_json_path(path)
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should be:$/ do |path, json|
  last_json.should be_json_eql(json).at_path(path)
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|\{.*\}|true|false|null)$/ do |path, value|
  last_json.should be_json_eql(value).at_path(path)
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should have (\d+)/ do |path, size|
  last_json.should have_json_size(size.to_i).at_path(path)
end
