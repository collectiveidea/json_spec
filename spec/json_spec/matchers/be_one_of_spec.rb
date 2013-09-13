require "spec_helper"

describe JsonSpec::Matchers::BeOneOf do

  context "with positive case" do

    it "matches a hash" do
      json = %({"a": 1, "b": 2})
      json.should be_one_of(%({"b": 2}), json)
    end

    it "matches an array" do
      json = %([1, 2, 3])
      json.should be_one_of(%([3, 4, 5]), json)
    end

    describe "message" do
      let(:matcher) { be_one_of("1", "2", "3") }

      it "provides a description message" do
        matcher.matches?(%(2))
        matcher.description.should == %(is one of ["1", "2", "3"])
      end

      it "provides a description message with path" do
        matcher.at_path("b")
        matcher.matches?(%({"a": 1, "b": 2}))
        matcher.description.should == %(is one of ["1", "2", "3"] at path "b")
      end
    end

    context "with excluding keys" do
      before { JsonSpec.exclude_keys("ignore") }

      it "behaviors like be_json_eql matcher" do
        %({"json": "spec", "ignore": "please"}).should be_one_of(
          %({"test": "json"}),
          %({"json": "spec"})
        )
      end

      it "ignores excluding keys when resolves path specification" do
        %({"json": [1, 2], "ignore": [3, 4]}).should be_one_of(
          %([5, 6]),
          %([3, 4])
        ).at_path("ignore")
      end
    end

    context "with single value" do
      it "matches with single integer" do
        %(3).should be_one_of("1"," 2", "3")
      end

      it "matches with single float" do
        %(2.5).should be_one_of("2.0", "2.5", "3.0")
      end

      it "matches with single string" do
        %("value").should be_one_of(%("test"), %("value"))
      end
    end

    context "with specific path in a hash" do
      it "matches with single expected value" do
        %({"a": 1, "b": 2, "c": 3}).should be_one_of("2").at_path("b")
      end

      it "matches with multiple expected values" do
        %({"a": 1, "b": 2, "c": 3}).should be_one_of("1", "2", "3").at_path("b")
      end
    end

    context "with specific path in a array" do
      it "matches with single expected value" do
        %([1, 2, 3]).should be_one_of("2").at_path("1")
      end

      it "matches with multiple expected values" do
        %([1, 2, 3]).should be_one_of("1", "2", "3").at_path("1")
      end
    end
  end


  context "with negative case" do
    context "with single value" do
      it "matches with single integer" do
        %(3).should_not be_one_of("1", "2")
      end

      it "matches with single float" do
        %(2.0).should_not be_one_of("2", "2.5")
      end

      it "matches with single string" do
        %("value").should_not be_one_of(%("test"), %("json"))
      end
    end

    it "doesn't match out-of-order arrays" do
      %(["json", "spec"]).should_not be_one_of(%(["spec","json"]))
    end

    it "doesn't match Ruby-equivalent, JSON-inequivalent values" do
      %({"one": 1}).should_not be_one_of("1.0", "2.0").at_path("one")
    end
  end


  context "when not given expected JSON" do
    context "with positive case" do
      it "raises an ExpectationNotMetError" do
        expect {
          %({"a": 1, "b": 2}).should be_one_of("1", "3", "5").at_path("b")
        }.to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end

    context "with negative case" do
      it "raises an ExpectationNotMetError" do
        expect {
          %({"a": 1, "b": 2}).should_not be_one_of("1", "2", "3").at_path("b")
        }.to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end

    context "with invalid path" do
      it "raises JsonSpec::MissingPath" do
        expect {
          %({"a": 1, "b": 2}).should be_one_of("1", "3").at_path("x")
        }.to raise_error JsonSpec::MissingPath
      end
    end
  end

end
