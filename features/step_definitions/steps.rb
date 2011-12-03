Given "the JSON is:" do |json|
  @json = json
end

When "I get the JSON" do
  @last_json = @json
end

When /^I get the JSON from "(.*)"$/ do |relative_path|
  @last_json = JsonSpec::Helpers.load_json(relative_path)
end