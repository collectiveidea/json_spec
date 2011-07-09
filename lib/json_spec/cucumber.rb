require File.expand_path("../../json_spec", __FILE__)

World(JsonSpec::Helpers)

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

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |path, negative, value|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(value)).at_path(path)
  else
    last_json.should be_json_eql(JsonSpec.remember(value)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)? should( not)? have "(.*)"$/ do |negative, path|
  if negative
    last_json.should_not have_json_path(path)
  else
    last_json.should have_json_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be an? (.*)$/ do |path, negative, type|
  klass = Module.const_get(type.gsub(/^./){|x| x.upcase })
  if negative
    last_json.should_not have_json_type(klass).at_path(path)
  else
    last_json.should have_json_type(klass).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have (\d+)/ do |path, negative, size|
  if negative
    last_json.should_not have_json_size(size.to_i).at_path(path)
  else
    last_json.should have_json_size(size.to_i).at_path(path)
  end
end
