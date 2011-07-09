require "spec_helper"

describe "Matchers:" do
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

    it "matches valid JSON values, yet invalid JSON documents" do
      %("json_spec").should be_json_eql(%("json_spec"))
    end

    it "matches at a path" do
      %({"json":["spec"]}).should be_json_eql(%("spec")).at_path("json/0")
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

    it "includes globally-excluded hash keys per matcher" do
      JsonSpec.excluded_keys = %w(id ignore)
      %({"id":1,"json":"spec","ignore":"please"}).should_not be_json_eql(%({"id":2,"json":"spec","ignore":"this"})).including("id")
    end

    it "includes globally-included hash keys given as symbols" do
      JsonSpec.excluded_keys = %w(id)
      %({"id":1,"json":"spec"}).should_not be_json_eql(%({"id":2,"json":"spec"})).including(:id)
    end
  end

  context "have_json_size" do
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
  end

  context "have_json_path" do
    it "matches hash keys" do
      %({"one":{"two":{"three":4}}}).should have_json_path("one/two/three")
    end

    it "doesn't match values" do
      %({"one":{"two":{"three":4}}}).should_not have_json_path("one/two/three/4")
    end

    it "matches array indexes" do
      %([1,[1,2,[1,2,3,4]]]).should have_json_path("1/2/3")
    end

    it "respects null array values" do
      %([null,[null,null,[null,null,null,null]]]).should have_json_path("1/2/3")
    end

    it "matches hash keys and array indexes" do
      %({"one":[1,2,{"three":4}]}).should have_json_path("one/2/three")
    end
  end

  context "have_json_type" do
    it "matches hashes" do
      %({}).should have_json_type(Hash)
    end

    it "matches arrays" do
      %([]).should have_json_type(Array)
    end

    it "matches at a path" do
      %({"root":[]}).should have_json_type(Array).at_path("root")
    end

    it "matches strings" do
      %(["json_spec"]).should have_json_type(String).at_path("0")
    end

    it "matches a valid JSON value, yet invalid JSON document" do
      %("json_spec").should have_json_type(String)
    end

    it "matches empty strings" do
      %("").should have_json_type(String)
    end

    it "matches integers" do
      %(10).should have_json_type(Integer)
    end

    it "matches floats" do
      %(10.0).should have_json_type(Float)
      %(1e+1).should have_json_type(Float)
    end

    it "matches ancestor classes" do
      %(10).should have_json_type(Numeric)
      %(10.0).should have_json_type(Numeric)
    end

    context "somewhat uselessly" do
      it "matches true" do
        %(true).should have_json_type(TrueClass)
      end

      it "matches false" do
        %(false).should have_json_type(FalseClass)
      end

      it "matches null" do
        %(null).should have_json_type(NilClass)
      end
    end
  end
end
