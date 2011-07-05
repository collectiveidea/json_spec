require "spec_helper"

describe "Matcher:" do
  context "be_json_eql" do
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

    it "ignores excluded-by-default hash keys" do
      JsonSpec.excluded_keys.should_not be_empty

      actual = expected = {"json" => "spec"}
      JsonSpec.excluded_keys.each{|k| actual[k] = k }
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

    it "excludes extra hash keys per matcher" do
      JsonSpec.excluded_keys = %w(ignore)
      %({"id":1,"json":"spec","ignore":"please"}).should be_json_eql(%({"id":"2","json":"spec","ignore":"this"})).excluding("id")
    end

    it "excludes extra hash keys given as symbols" do
      JsonSpec.excluded_keys = []
      %({"id":1,"json":"spec"}).should be_json_eql(%({"id":2,"json":"spec"})).excluding(:id)
    end

    it "includes globally-excluded hash keys per matcher" do
      JsonSpec.excluded_keys = %w(id ignore)
      %({"id":1,"json":"spec","ignore":"please"}).should_not be_json_eql(%({"id":"2","json":"spec","ignore":"this"})).including("id")
    end

    it "includes globally-included hash keys given as symbols" do
      JsonSpec.excluded_keys = %w(id)
      %({"id":1,"json":"spec"}).should_not be_json_eql(%({"id":2,"json":"spec"})).including(:id)
    end
  end
end
