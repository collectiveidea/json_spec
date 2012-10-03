require "spec_helper"

describe JsonSpec::Matchers::HaveJsonType do
  it "matches hashes" do
    hash = %({})
    hash.should have_json_type(Hash)
    hash.should have_json_type(:object)
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

  it "matches booleans" do
    %(true).should have_json_type(:boolean)
    %(false).should have_json_type(:boolean)
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

  it "provides a description message" do
    matcher = have_json_type(String)
    matcher.matches?(%({"id":1,"json":"spec"}))
    matcher.description.should == %(have JSON type "String")
  end

  it "provides a description message with path" do
    matcher = have_json_type(String).at_path("json")
    matcher.matches?(%({"id":1,"json":"spec"}))
    matcher.description.should == %(have JSON type "String" at path "json")
  end

  context "somewhat uselessly" do
    it "matches true" do
      %(true).should have_json_type(TrueClass)
    end

    it "matches false" do
      %(false).should have_json_type(FalseClass)
    end

    it "matches null" do
      null = %(null)
      null.should have_json_type(NilClass)
      null.should have_json_type(:nil)
      null.should have_json_type(:null)
    end
  end
end
