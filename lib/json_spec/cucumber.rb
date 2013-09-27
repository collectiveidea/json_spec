require File.expand_path("../../json_spec", __FILE__)

World(JsonSpec::Helpers, JsonSpec::Matchers)

After do
  JsonSpec.forget
end

When /^(?:I )?keep the (?:JSON|json)(?: response)?(?: at "(.*)")? as "(.*)"$/ do |path, key|
  JsonSpec.memorize(key, normalize_json(last_json, path))
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be:$/ do |path, negative, json|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(json)).at_path(path)
  else
    last_json.should be_json_eql(JsonSpec.remember(json)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be file "(.+)"$/ do |path, negative, file_path|
  if negative
    last_json.should_not be_json_eql.to_file(file_path).at_path(path)
  else
    last_json.should be_json_eql.to_file(file_path).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |path, negative, value|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(value)).at_path(path)
  else
    last_json.should be_json_eql(JsonSpec.remember(value)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include:$/ do |path, negative, json|
  if negative
    last_json.should_not include_json(JsonSpec.remember(json)).at_path(path)
  else
    last_json.should include_json(JsonSpec.remember(json)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include file "(.+)"$/ do |path, negative, file_path|
  if negative
    last_json.should_not include_json.from_file(file_path).at_path(path)
  else
    last_json.should include_json.from_file(file_path).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |path, negative, value|
  if negative
    last_json.should_not include_json(JsonSpec.remember(value)).at_path(path)
  else
    last_json.should include_json(JsonSpec.remember(value)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should have the following:$/ do |base, table|
  table.raw.each do |path, value|
    path = [base, path].compact.join("/")

    if value
      step %(the JSON at "#{path}" should be:), value
    else
      step %(the JSON should have "#{path}")
    end
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have the following keys:$/ do |base, negative, table|
  match = have_json_keys(table.raw)
  match = match.at_path(base) if base
  if negative
    last_json.should_not match
  else
    last_json.should match
  end
end

Then /^the (?:JSON|json)(?: response)? should( not)? have "(.*)"$/ do |negative, path|
  if negative
    last_json.should_not have_json_path(path)
  else
    last_json.should have_json_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have keys (.*)$/ do |base, negative, keys|
  keys = eval("[#{keys}]")
  match = have_json_keys(keys)
  match = match.at_path(base) if base
  if negative
    last_json.should_not match
  else
    last_json.should match
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be an? (.*)$/ do |path, negative, type|
  if negative
    last_json.should_not have_json_type(type).at_path(path)
  else
    last_json.should have_json_type(type).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have (\d+)/ do |path, negative, size|
  if negative
    last_json.should_not have_json_size(size.to_i).at_path(path)
  else
    last_json.should have_json_size(size.to_i).at_path(path)
  end
end
