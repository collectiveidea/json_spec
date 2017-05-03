require "spec_helper"

describe JsonSpec::Configuration do
  it "excludes id and timestamps by default" do
    JsonSpec.excluded_keys.should eq ["id", "created_at", "updated_at"]
  end

  it "excludes custom keys" do
    JsonSpec.exclude_keys("token")
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "excludes custom keys via setter" do
    JsonSpec.excluded_keys = ["token"]
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "excludes custom keys via block" do
    JsonSpec.configure { |c| c.exclude_keys("token") }
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "excludes custom keys via block setter" do
    JsonSpec.configure { |c| c.excluded_keys = ["token"] }
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "excludes custom keys via instance-evaluated block" do
    JsonSpec.configure{ exclude_keys("token") }
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "ensures its excluded keys are strings" do
    JsonSpec.exclude_keys(:token)
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "ensures its excluded keys are unique" do
    JsonSpec.exclude_keys("token", :token)
    JsonSpec.excluded_keys.should eq ["token"]
  end

  it "resets its excluded keys" do
    original = JsonSpec.excluded_keys

    JsonSpec.exclude_keys("token")
    JsonSpec.excluded_keys.should_not eq original

    JsonSpec.reset
    JsonSpec.excluded_keys.should eq original
  end

  it "resets its directory" do
    JsonSpec.directory.should be_nil

    JsonSpec.directory = "/"
    JsonSpec.directory.should_not be_nil

    JsonSpec.reset
    JsonSpec.directory.should be_nil
  end
end
