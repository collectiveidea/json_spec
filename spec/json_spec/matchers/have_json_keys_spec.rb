require "spec_helper"

describe JsonSpec::Matchers::HaveJsonKeys do
  it "fails for non-hashes" do
    %([1,2,3]).should_not have_json_keys
    %(1).should_not have_json_keys
    %("test").should_not have_json_keys
  end

  it "fails when one key is missing" do
    %({"a": "1", "b": "2"}).should_not have_json_keys(:a, :b, :c)
  end

  it "matches for equal set of keys" do
    [:a, :b, :c].permutation.each do |keys|
      %({"a": "1", "b": "2", "c": "3"}).should have_json_keys(*keys)
    end
  end

  it "matches for smaller set of keys" do
    %({"a": "1", "b": "2", "c": "3"}).should have_json_keys(:a, :b)
  end

  it "matches for empty set of keys" do
    %({"a": "1", "b": "2", "c": "3"}).should have_json_keys
  end

  it "accepts array of symbol keys" do
    %({"a": "1", "b": "2"}).should have_json_keys([:a, :b])
  end

  it "accepts array of string keys" do
    %({"a": "1", "b": "2"}).should have_json_keys(['a', 'b'])
  end

  it "accepts symbol keys" do
    %({"a": "1", "b": "2"}).should have_json_keys(:a, :b)
  end

  it "accepts string keys" do
    %({"a": "1", "b": "2"}).should have_json_keys('a', 'b')
  end
end
