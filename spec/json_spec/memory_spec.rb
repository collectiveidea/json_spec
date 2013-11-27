require "spec_helper"

describe JsonSpec::Memory do
  it "has a memory" do
    expect(JsonSpec.memory).to eq({})
  end

  it "memorizes strings" do
    JsonSpec.memorize(:key, "value")
    expect(JsonSpec.memory).to eq({:key => "value"})
  end

  it "symbolizes keys" do
    JsonSpec.memorize("key", "value")
    expect(JsonSpec.memory).to eq({:key => "value"})
  end

  it "regurgitates unremembered strings" do
    expect(JsonSpec.remember("foo%{bar}")).to eq("foo%{bar}")
  end

  it "remembers strings" do
    JsonSpec.memorize(:bar, "baz")
    expect(JsonSpec.remember("foo%{bar}")).to eq("foobaz")
  end

  it "forgets" do
    JsonSpec.memorize(:key, "value")
    JsonSpec.forget
    expect(JsonSpec.memory).to eq({})
  end
end
