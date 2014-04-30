require 'spec_helper'

describe JsonSpec::Matchers::Have do

  context 'matches by default' do
    it 'symbol as integer' do
      %({"one":1}).should have :one
    end

    it 'string as string' do
      %({"one":"one"}).should have 'one'
    end
  end

  context 'matches defined type' do
    it 'key as symbol' do
      %({"one":true}).should have :one, TrueClass
    end
    it 'key as string' do
      %({"one":true}).should have 'one', TrueClass
    end
  end

  it 'matches hash keys' do
    %({"one":{"two":{"three":4}}}).should have 'one/two/three', Integer
  end

  it "doesn't match values" do
    %({"one":{"two":{"three":4}}}).should_not have 'one/two/three', String
  end

  it "provides a description message" do
    matcher = have 'json'
    matcher.matches?(%({"id":1,"json":"spec"}))
    matcher.description.should == %(have JSON type "String" at path "json")
  end

end
