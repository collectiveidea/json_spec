require "spec_helper"

describe JsonSpec::Matchers::HaveJsonType do
  it "matches hashes" do
    hash = %({})
    expect(hash).to have_json_type(Hash)
    expect(hash).to have_json_type(:object)
  end

  it "matches arrays" do
    expect(%([])).to have_json_type(Array)
  end

  it "matches at a path" do
    expect(%({"root":[]})).to have_json_type(Array).at_path("root")
  end

  it "matches strings" do
    expect(%(["json_spec"])).to have_json_type(String).at_path("0")
  end

  it "matches a valid JSON value, yet invalid JSON document" do
    expect(%("json_spec")).to have_json_type(String)
  end

  it "matches empty strings" do
    expect(%("")).to have_json_type(String)
  end

  it "matches integers" do
    expect(%(10)).to have_json_type(Integer)
  end

  it "matches floats" do
    expect(%(10.0)).to have_json_type(Float)
    expect(%(1e+1)).to have_json_type(Float)
  end

  it "matches booleans" do
    expect(%(true)).to have_json_type(:boolean)
    expect(%(false)).to have_json_type(:boolean)
  end

  it "matches ancestor classes" do
    expect(%(10)).to have_json_type(Numeric)
    expect(%(10.0)).to have_json_type(Numeric)
  end

  it "provides a failure message for should" do
    matcher = have_json_type(Numeric)
    matcher.matches?(%("foo"))
    expect(matcher.failure_message_for_should).to eq("Expected JSON value type to be Numeric, got String")
  end

  it "provides a failure message for should not" do
    matcher = have_json_type(Numeric)
    matcher.matches?(%(10))
    expect(matcher.failure_message_for_should_not).to eq("Expected JSON value type to not be Numeric, got Fixnum")
  end

  it "provides a description message" do
    matcher = have_json_type(String)
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq(%(have JSON type "String"))
  end

  it "provides a description message with path" do
    matcher = have_json_type(String).at_path("json")
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq(%(have JSON type "String" at path "json"))
  end

  context "somewhat uselessly" do
    it "matches true" do
      expect(%(true)).to have_json_type(TrueClass)
    end

    it "matches false" do
      expect(%(false)).to have_json_type(FalseClass)
    end

    it "matches null" do
      null = %(null)
      expect(null).to have_json_type(NilClass)
      expect(null).to have_json_type(:nil)
      expect(null).to have_json_type(:null)
    end
  end
end
