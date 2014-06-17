require "spec_helper"

describe JsonSpec::Memory do
  it "has a memory" do
    JsonSpec.memory.should == {}
  end

  it "memorizes strings" do
    JsonSpec.memorize(:key, "value")
    JsonSpec.memory.should == { key: "value" }
  end

  it "symbolizes keys" do
    JsonSpec.memorize("key", "value")
    JsonSpec.memory.should == { key: "value" }
  end

  it "regurgitates unremembered strings" do
    JsonSpec.remember("foo%{bar}").should == "foo%{bar}"
  end

  it "remembers strings" do
    JsonSpec.memorize(:bar, "baz")
    JsonSpec.remember("foo%{bar}").should == "foobaz"
  end

  it "forgets" do
    JsonSpec.memorize(:key, "value")
    JsonSpec.forget
    JsonSpec.memory.should == {}
  end
end
