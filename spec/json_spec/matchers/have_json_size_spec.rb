require "spec_helper"

describe JsonSpec::Matchers::HaveJsonSize do
  it "counts array entries" do
    %([1,2,3]).should have_json_size(3)
  end

  it "counts null array entries" do
    %([1,null,3]).should have_json_size(3)
  end

  it "counts hash key/value pairs" do
    %({"one":1,"two":2,"three":3}).should have_json_size(3)
  end

  it "counts null hash values" do
    %({"one":1,"two":null,"three":3}).should have_json_size(3)
  end

  it "matches at a path" do
    %({"one":[1,2,3]}).should have_json_size(3).at_path("one")
  end

  it "provides a failure message" do
    matcher = have_json_size(3)
    matcher.matches?(%([1,2]))
    matcher.failure_message.should            eq "Expected JSON value size to be 3, got 2"
    matcher.failure_message_for_should.should eq "Expected JSON value size to be 3, got 2" # RSpec 2 interface
  end

  it "provides a failure message for negation" do
    matcher = have_json_size(3)
    matcher.matches?(%([1,2,3]))
    matcher.failure_message_when_negated.should   eq "Expected JSON value size to not be 3, got 3"
    matcher.failure_message_for_should_not.should eq "Expected JSON value size to not be 3, got 3" # RSpec 2 interface
  end

  it "provides a description message" do
    matcher = have_json_size(1)
    matcher.matches?(%({"id":1,"json":["spec"]}))
    matcher.description.should eq %(have JSON size "1")
  end

  it "provides a description message with path" do
    matcher = have_json_size(1).at_path("json")
    matcher.matches?(%({"id":1,"json":["spec"]}))
    matcher.description.should eq %(have JSON size "1" at path "json")
  end

  it "provides an error when parsing nil" do
    matcher = have_json_size(0).at_path("json")
    expect { matcher.matches?(%({"id":1,"json":null})) }.to raise_error(JsonSpec::EnumerableExpected,
                                                                          "Enumerable expected, got nil")
  end

  it "provides an error when parsing non-enumerables" do
    matcher = have_json_size(0).at_path("json")
    expect { matcher.matches?(%({"id":1,"json":12345})) }.to raise_error(JsonSpec::EnumerableExpected,
                                                                           "Enumerable expected, got 12345")
  end
end
