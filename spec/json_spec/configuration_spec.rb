require "spec_helper"

describe JsonSpec::Configuration do
  it "excludes id and timestamps by default" do
    expect(JsonSpec.excluded_keys).to eq(["id", "created_at", "updated_at"])
  end

  it "excludes custom keys" do
    JsonSpec.exclude_keys("token")
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "excludes custom keys via setter" do
    JsonSpec.excluded_keys = ["token"]
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "excludes custom keys via block" do
    JsonSpec.configure{|c| c.exclude_keys("token") }
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "excludes custom keys via block setter" do
    JsonSpec.configure{|c| c.excluded_keys = ["token"] }
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "excludes custom keys via instance-evaluated block" do
    JsonSpec.configure{ exclude_keys("token") }
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "ensures its excluded keys are strings" do
    JsonSpec.exclude_keys(:token)
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "ensures its excluded keys are unique" do
    JsonSpec.exclude_keys("token", :token)
    expect(JsonSpec.excluded_keys).to eq(["token"])
  end

  it "resets its excluded keys" do
    original = JsonSpec.excluded_keys

    JsonSpec.exclude_keys("token")
    expect(JsonSpec.excluded_keys).not_to eq(original)

    JsonSpec.reset
    expect(JsonSpec.excluded_keys).to eq(original)
  end

  it "resets its directory" do
    expect(JsonSpec.directory).to be_nil

    JsonSpec.directory = "/"
    expect(JsonSpec.directory).not_to be_nil

    JsonSpec.reset
    expect(JsonSpec.directory).to be_nil
  end
end
