require "spec_helper"

describe JsonSpec::Matchers::HaveJsonSize do
  it "counts array entries" do
    expect(%([1,2,3])).to have_json_size(3)
  end

  it "counts null array entries" do
    expect(%([1,null,3])).to have_json_size(3)
  end

  it "counts hash key/value pairs" do
    expect(%({"one":1,"two":2,"three":3})).to have_json_size(3)
  end

  it "counts null hash values" do
    expect(%({"one":1,"two":null,"three":3})).to have_json_size(3)
  end

  it "matches at a path" do
    expect(%({"one":[1,2,3]})).to have_json_size(3).at_path("one")
  end

  it "provides a failure message for should" do
    matcher = have_json_size(3)
    matcher.matches?(%([1,2]))
    expect(matcher.failure_message_for_should).to eq("Expected JSON value size to be 3, got 2")
  end

  it "provides a failure message for should not" do
    matcher = have_json_size(3)
    matcher.matches?(%([1,2,3]))
    expect(matcher.failure_message_for_should_not).to eq("Expected JSON value size to not be 3, got 3")
  end

  it "provides a description message" do
    matcher = have_json_size(1)
    matcher.matches?(%({"id":1,"json":["spec"]}))
    expect(matcher.description).to eq(%(have JSON size "1"))
  end

  it "provides a description message with path" do
    matcher = have_json_size(1).at_path("json")
    matcher.matches?(%({"id":1,"json":["spec"]}))
    expect(matcher.description).to eq(%(have JSON size "1" at path "json"))
  end
end
