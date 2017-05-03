require "spec_helper"

describe JsonSpec::Matchers::IncludeJson do
  it "matches included array elements" do
    json = %(["one",1,1.0,true,false,null])
    json.should include_json(%("one"))
    json.should include_json(%(1))
    json.should include_json(%(1.0))
    json.should include_json(%(true))
    json.should include_json(%(false))
    json.should include_json(%(null))
  end

  it "matches an array included in an array" do
    json = %([[1,2,3],[4,5,6]])
    json.should include_json(%([1,2,3]))
    json.should include_json(%([4,5,6]))
  end

  it "matches a hash included in an array" do
    json = %([{"one":1},{"two":2}])
    json.should include_json(%({"one":1}))
    json.should include_json(%({"two":2}))
  end

  it "matches included hash values" do
    json = %({"string":"one","integer":1,"float":1.0,"true":true,"false":false,"null":null})
    json.should include_json(%("one"))
    json.should include_json(%(1))
    json.should include_json(%(1.0))
    json.should include_json(%(true))
    json.should include_json(%(false))
    json.should include_json(%(null))
  end

  it "matches a hash included in a hash" do
    json = %({"one":{"two":3},"four":{"five":6}})
    json.should include_json(%({"two":3}))
    json.should include_json(%({"five":6}))
  end

  it "matches an array included in a hash" do
    json = %({"one":[2,3],"four":[5,6]})
    json.should include_json(%([2,3]))
    json.should include_json(%([5,6]))
  end

  it "matches a substring" do
    json = %("json")
    json.should include_json(%("js"))
    json.should include_json(%("json"))
  end

  it "matches at a path" do
    %({"one":{"two":[3,4]}}).should include_json(%([3,4])).at_path("one")
  end

  it "ignores excluded keys" do
    %([{"id":1,"two":3}]).should include_json(%({"two":3}))
  end

  it "provides a description message" do
    matcher = include_json(%({"json":"spec"}))
    matcher.matches?(%({"id":1,"json":"spec"}))
    matcher.description.should == "include JSON"
  end

  it "provides a description message with path" do
    matcher = include_json(%("spec")).at_path("json/0")
    matcher.matches?(%({"id":1,"json":["spec"]}))
    matcher.description.should == %(include JSON at path "json/0")
  end

  it "provides a useful failure message for should" do
    matcher = include_json(%([4,5,6]))
    matcher.matches?(%([1,2,3]))
    matcher.failure_message_for_should.should == "Expected [1,2,3] to include [4,5,6]"
  end

  it "provides a useful failure message for should not" do
    matcher = include_json(%(3))
    matcher.matches?(%([1,2,3]))
    matcher.failure_message_for_should_not.should == "Expected [1,2,3] to not include 3"
  end

  it "raises an error when not given expected JSON" do
    expect{ %([{"id":1,"two":3}]).should include_json }.to raise_error do |error|
      error.message.should == "Expected included JSON not provided"
    end
  end

  it "matches file contents" do
    JsonSpec.directory = files_path
    %({"one":{"value":"from_file"},"four":{"five":6}}).should include_json.from_file("one.json")
  end
end
