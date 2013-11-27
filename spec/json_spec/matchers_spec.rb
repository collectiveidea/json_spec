require "spec_helper"

describe JsonSpec::Matchers do
  let(:environment) do
    klass = Class.new
    klass.send(:include, JsonSpec::Matchers)
    klass.new
  end

  let(:json){ %({"json":"spec"}) }

  context "be_json_eql" do
    it "instantiates its matcher" do
      expect(JsonSpec::Matchers::BeJsonEql).to receive(:new).with(json)
      environment.be_json_eql(json)
    end

    it "returns its matcher" do
      matcher = environment.be_json_eql(json)
      expect(matcher).to be_a(JsonSpec::Matchers::BeJsonEql)
    end
  end

  context "include_json" do
    it "instantiates its matcher" do
      expect(JsonSpec::Matchers::IncludeJson).to receive(:new).with(json)
      environment.include_json(json)
    end

    it "returns its matcher" do
      matcher = environment.include_json(json)
      expect(matcher).to be_a(JsonSpec::Matchers::IncludeJson)
    end
  end

  context "have_json_path" do
    let(:path){ "json" }

    it "instantiates its matcher" do
      expect(JsonSpec::Matchers::HaveJsonPath).to receive(:new).with(path)
      environment.have_json_path(path)
    end

    it "returns its matcher" do
      matcher = environment.have_json_path(path)
      expect(matcher).to be_a(JsonSpec::Matchers::HaveJsonPath)
    end
  end

  context "have_json_type" do
    let(:type){ Hash }

    it "instantiates its matcher" do
      expect(JsonSpec::Matchers::HaveJsonType).to receive(:new).with(type)
      environment.have_json_type(type)
    end

    it "returns its matcher" do
      matcher = environment.have_json_type(type)
      expect(matcher).to be_a(JsonSpec::Matchers::HaveJsonType)
    end
  end

  context "have_json_size" do
    let(:size){ 1 }

    it "instantiates its matcher" do
      expect(JsonSpec::Matchers::HaveJsonSize).to receive(:new).with(size)
      environment.have_json_size(size)
    end

    it "returns its matcher" do
      matcher = environment.have_json_size(size)
      expect(matcher).to be_a(JsonSpec::Matchers::HaveJsonSize)
    end
  end
end
