require "spec_helper"

describe JsonSpec::Matchers::HaveJsonValue do
  it "matches value at root path" do
    %("bar").should have_json_value("bar")
  end

  it "matches value at path" do
    %({"foo": "bar"}).should have_json_value("bar").at_path("foo")
  end

  it "matches value at deep path" do
    %({"foo": {"pipe": "bar"}}).should have_json_value("bar").at_path("foo/pipe")
  end

  it "provides a failure message" do
    matcher = have_json_value("pipe")
    matcher.matches?(%("bar"))
    matcher.failure_message.should            == "Expected JSON value to be \"pipe\", got \"bar\""
    matcher.failure_message_for_should.should == "Expected JSON value to be \"pipe\", got \"bar\"" # RSpec 2 interface
  end

  it "provides a failure message for negation" do
    matcher = have_json_value("pipe")
    matcher.matches?(%("bar"))
    matcher.failure_message_when_negated.should   == "Expected JSON value to not be \"pipe\", got \"bar\""
    matcher.failure_message_for_should_not.should == "Expected JSON value to not be \"pipe\", got \"bar\"" # RSpec 2 interface
  end

  it "provides a description message" do
    matcher = have_json_value("pipe")
    matcher.matches?(%("pipe"))
    matcher.description.should == %(have JSON value "pipe")
  end

  it "provides a description message with path" do
    matcher = have_json_value("pipe").at_path("json")
    matcher.matches?(%({"id":1,"json":"pipe"}))
    matcher.description.should == %(have JSON value "pipe" at path "json")
  end
end
