require "spec_helper"

describe JsonSpec::Matchers::IncludeJson do
  it "matches included array elements" do
    json = %(["one",1,1.0,true,false,null])
    expect(json).to include_json(%("one"))
    expect(json).to include_json(%(1))
    expect(json).to include_json(%(1.0))
    expect(json).to include_json(%(true))
    expect(json).to include_json(%(false))
    expect(json).to include_json(%(null))
  end

  it "matches an array included in an array" do
    json = %([[1,2,3],[4,5,6]])
    expect(json).to include_json(%([1,2,3]))
    expect(json).to include_json(%([4,5,6]))
  end

  it "matches a hash included in an array" do
    json = %([{"one":1},{"two":2}])
    expect(json).to include_json(%({"one":1}))
    expect(json).to include_json(%({"two":2}))
  end

  it "matches included hash values" do
    json = %({"string":"one","integer":1,"float":1.0,"true":true,"false":false,"null":null})
    expect(json).to include_json(%("one"))
    expect(json).to include_json(%(1))
    expect(json).to include_json(%(1.0))
    expect(json).to include_json(%(true))
    expect(json).to include_json(%(false))
    expect(json).to include_json(%(null))
  end

  it "matches a hash included in a hash" do
    json = %({"one":{"two":3},"four":{"five":6}})
    expect(json).to include_json(%({"two":3}))
    expect(json).to include_json(%({"five":6}))
  end

  it "matches an array included in a hash" do
    json = %({"one":[2,3],"four":[5,6]})
    expect(json).to include_json(%([2,3]))
    expect(json).to include_json(%([5,6]))
  end

  it "matches a substring" do
    json = %("json")
    expect(json).to include_json(%("js"))
    expect(json).to include_json(%("json"))
  end

  it "matches at a path" do
    expect(%({"one":{"two":[3,4]}})).to include_json(%([3,4])).at_path("one")
  end

  it "ignores excluded keys" do
    expect(%([{"id":1,"two":3}])).to include_json(%({"two":3}))
  end

  it "provides a description message" do
    matcher = include_json(%({"json":"spec"}))
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq("include JSON")
  end

  it "provides a description message with path" do
    matcher = include_json(%("spec")).at_path("json/0")
    matcher.matches?(%({"id":1,"json":["spec"]}))
    expect(matcher.description).to eq(%(include JSON at path "json/0"))
  end

  it "raises an error when not given expected JSON" do
    expect{ expect(%([{"id":1,"two":3}])).to include_json }.to raise_error
  end

  it "matches file contents" do
    JsonSpec.directory = files_path
    expect(%({"one":{"value":"from_file"},"four":{"five":6}})).to include_json.from_file("one.json")
  end
end
