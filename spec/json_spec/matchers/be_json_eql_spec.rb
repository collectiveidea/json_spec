require "spec_helper"

describe JsonSpec::Matchers::BeJsonEql do
  it "matches identical JSON" do
    %({"json":"spec"}).should be_json_eql(%({"json":"spec"}))
  end

  it "matches differently-formatted JSON" do
    %({"json": "spec"}).should be_json_eql(%({"json":"spec"}))
  end

  it "matches out-of-order hashes" do
    %({"laser":"lemon","json":"spec"}).should be_json_eql(%({"json":"spec","laser":"lemon"}))
  end

  it "doesn't match out-of-order arrays" do
    %(["json","spec"]).should_not be_json_eql(%(["spec","json"]))
  end

  it "matches out-of-order arrays when chained with in_any_order" do
    %(["json","spec"]).should be_json_eql(%(["spec","json"])).in_any_order
  end

  it "matches out-of-order hashes when chained with in_any_order" do
    %({"laser":"lemon","json":"spec"}).should be_json_eql(%({"json":"spec","laser":"lemon"})).in_any_order
  end

  it "doesn't match out-of-order arrays when chained with in_any_order if passed false" do
    %(["json","spec"]).should_not be_json_eql(%(["spec","json"])).in_any_order(false)
  end

  it "matches complex nested out-of-order arrays when chained with in_any_order" do
    %({"json":[{"spec":4,"laser":[{"id":2,"lemon":"a"},{"id":5,"lemon":"b"}]},{"spec":9,"laser":[{"id":3,"lemon":"c"},{"id":1,"lemon":"d"}]}]}).should be_json_eql(%({"json":[{"laser":[{"lemon":"d","id":1},{"lemon":"c","id":3}],"spec":9},{"laser":[{"lemon":"b","id":5},{"lemon":"a","id":2}],"spec":4}]})).in_any_order
  end

  it "matches valid JSON values, yet invalid JSON documents" do
    %("json_spec").should be_json_eql(%("json_spec"))
  end

  it "matches at a path" do
    %({"json":["spec"]}).should be_json_eql(%("spec")).at_path("json/0")
  end

  it "matches out-of-order arrays at a path when chained with in_any_order" do
    %({"json":[{"spec":[4,2,3,1,5]}]}).should be_json_eql(%([1,2,3,4,5])).at_path("json/0/spec").in_any_order
  end

  it "ignores excluded-by-default hash keys" do
    JsonSpec.excluded_keys.should_not be_empty

    actual = expected = { "json" => "spec" }
    JsonSpec.excluded_keys.each { |k| actual[k] = k }
    actual.to_json.should be_json_eql(expected.to_json)
  end

  it "ignores custom excluded hash keys" do
    JsonSpec.exclude_keys("ignore")
    %({"json":"spec","ignore":"please"}).should be_json_eql(%({"json":"spec"}))
  end

  it "ignores nested, excluded hash keys" do
    JsonSpec.exclude_keys("ignore")
    %({"json":"spec","please":{"ignore":"this"}}).should be_json_eql(%({"json":"spec","please":{}}))
  end

  it "ignores hash keys when included in the expected value" do
    JsonSpec.exclude_keys("ignore")
    %({"json":"spec","ignore":"please"}).should be_json_eql(%({"json":"spec","ignore":"this"}))
  end

  it "doesn't match Ruby-equivalent, JSON-inequivalent values" do
    %({"one":1}).should_not be_json_eql(%({"one":1.0}))
  end

  it "matches different looking, JSON-equivalent values" do
    %({"ten":10.0}).should be_json_eql(%({"ten":1e+1}))
  end

  it "excludes extra hash keys per matcher" do
    JsonSpec.excluded_keys = %w(ignore)
    %({"id":1,"json":"spec","ignore":"please"}).should be_json_eql(%({"id":2,"json":"spec","ignore":"this"})).excluding("id")
  end

  it "excludes extra hash keys given as symbols" do
    JsonSpec.excluded_keys = []
    %({"id":1,"json":"spec"}).should be_json_eql(%({"id":2,"json":"spec"})).excluding(:id)
  end

  it "excludes extra hash keys given as symbols and matches out-of-order arrays when chained with in_any_order" do
    JsonSpec.excluded_keys = []
    %([{"id":1,"json":"spec"},{"id":4,"json":"laser"}]).should be_json_eql(%([{"id":3,"json":"laser"},{"id":2,"json":"spec"}])).excluding(:id).in_any_order
  end

  it "excludes multiple keys" do
    JsonSpec.excluded_keys = []
    %({"id":1,"json":"spec"}).should be_json_eql(%({"id":2,"json":"different"})).excluding(:id, :json)
  end

  it "includes globally-excluded hash keys per matcher" do
    JsonSpec.excluded_keys = %w(id ignore)
    %({"id":1,"json":"spec","ignore":"please"}).should_not be_json_eql(%({"id":2,"json":"spec","ignore":"this"})).including("id")
  end

  it "includes globally-included hash keys given as symbols" do
    JsonSpec.excluded_keys = %w(id)
    %({"id":1,"json":"spec"}).should_not be_json_eql(%({"id":2,"json":"spec"})).including(:id)
  end

  it "includes multiple keys" do
    JsonSpec.excluded_keys = %w(id json)
    %({"id":1,"json":"spec"}).should_not be_json_eql(%({"id":2,"json":"different"})).including(:id, :json)
  end

  it "provides a description message" do
    matcher = be_json_eql(%({"id":2,"json":"spec"}))
    matcher.matches?(%({"id":1,"json":"spec"}))
    matcher.description.should == "equal JSON"
  end

  it "provides a description message with path" do
    matcher = be_json_eql(%({"id":1,"json":["spec"]})).at_path("json/0")
    matcher.matches?(%({"id":1,"json":["spec"]}))
    matcher.description.should == %(equal JSON at path "json/0")
  end

  it "raises an error when not given expected JSON" do
    expect{ %({"id":1,"json":"spec"}).should be_json_eql }.to raise_error
  end

  it "matches file contents" do
    JsonSpec.directory = files_path
    %({ "value" : "from_file" }).should be_json_eql.to_file("one.json")
  end
end
