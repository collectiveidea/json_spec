Given "the JSON is:" do |json|
  @json = json
end

When "I get the JSON" do
  @last_json = @json
end
