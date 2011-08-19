require "spec_helper"

describe "Matchers:" do
  let(:files_root) { File.expand_path("../../../features/support/files", __FILE__) }
  
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
    
    it "should raise error if not passed an expected json value" do
      expect { %({"id":1,"json":"spec"}).should be_json_eql }.to raise_error
    end

    it "matches file contents" do
      JsonSpec.directory = files_root
      %({ "value" : "from_file" }).should be_json_eql.to_file("one.json")
    end
  end

  context "include_json" do
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

    it "matches include hash values" do
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

    it "matches at a path" do
      %({"one":{"two":[3,4]}}).should include_json(%([3,4])).at_path("one")
    end

    it "ignores excluded keys" do
      %([{"id":1,"two":3}]).should include_json(%({"two":3}))
    end
    
    it "should raise error if not passed an expected json value" do
      expect { %([{"id":1,"two":3}]).should include_json }.to raise_error
    end

    it "matches file contents" do
      JsonSpec.directory = files_root
      %({"one":{"value":"from_file"},"four":{"five":6}}).should include_json.from_file("one.json")
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

    it "provides a failure message for should" do
      matcher = have_json_size(3)
      matcher.matches?(%([1,2]))
      matcher.failure_message_for_should.should == "Expected JSON value size to be 3, got 2"
    end

    it "provides a failure message for should not" do
      matcher = have_json_size(3)
      matcher.matches?(%([1,2,3]))
      matcher.failure_message_for_should_not.should == "Expected JSON value size to not be 3, got 3"
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

    it "provides a failure message for should" do
      matcher = have_json_type(Numeric)
      matcher.matches?(%("foo"))
      matcher.failure_message_for_should.should == "Expected JSON value type to be Numeric, got String"
    end

    it "provides a failure message for should not" do
      matcher = have_json_type(Numeric)
      matcher.matches?(%(10))
      matcher.failure_message_for_should_not.should == "Expected JSON value type to not be Numeric, got Fixnum"
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
