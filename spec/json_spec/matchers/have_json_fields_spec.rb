require "spec_helper"

describe JsonSpec::Matchers::HaveJsonFields do
  it "fails for non-hashes" do
    %([1,2,3]).should_not have_json_fields([])
    %(1).should_not have_json_fields([])
    %("test").should_not have_json_fields([])
  end

  it "fails for non-complete set of fields" do
    %({"a": "a", "b": "b"}).should_not have_json_fields(%w(a b c))
    %({"a": "a", "b": "b"}).should_not have_json_fields([:a, :b, :c])
  end

  it "matches complete set of fields" do
    %({"a": "a", "b": "b", "c": "c"}).should have_json_fields(%w(a b c))
    %({"a": "a", "b": "b", "c": "c"}).should have_json_fields([:a, :b, :c])
  end
end
