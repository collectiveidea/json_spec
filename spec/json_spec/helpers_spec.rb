require "spec_helper"

describe JsonSpec::Helpers do
  include described_class

  context "parse_json" do
    it "parses JSON documents" do
      parse_json(%({"json":["spec"]})).should == {"json" => ["spec"]}
    end

    it "parses JSON values" do
      parse_json(%("json_spec")).should == "json_spec"
    end

    it "raises a parser error for invalid JSON" do
      expect{ parse_json("json_spec") }.to raise_error(JSON::ParserError)
    end

    it "parses at a path if given" do
      json = %({"json":["spec"]})
      parse_json(json, "json").should == ["spec"]
      parse_json(json, "json/0").should == "spec"
    end

    it "raises an error for a missing path" do
      json = %({"json":["spec"]})
      %w(spec json/1).each do |path|
        expect{ parse_json(json, path) }.to raise_error(JsonSpec::MissingPathError)
      end
    end
  end

  context "normalize_json" do
    it "normalizes a JSON document" do
      normalized = <<-JSON
{
  "json": [
    "spec"
  ]
}
      JSON
      normalize_json(%({"json":["spec"]})).should == normalized.chomp
    end

    it "normalizes at a path" do
      normalize_json(%({"json":["spec"]}), "json/0").should == %("spec")
    end

    it "accepts a JSON value" do
      normalize_json(%("json_spec")).should == %("json_spec")
    end

    it "normalizes JSON values" do
      normalize_json(%(1e+1)).should == %(10.0)
    end
  end

  context "generate_normalized_json" do
    it "generates a normalized JSON document" do
      normalized = <<-JSON
{
  "json": [
    "spec"
  ]
}
      JSON
      generate_normalized_json({"json" => ["spec"]}).should == normalized.chomp
    end

    it "generates a normalized JSON value" do
      generate_normalized_json(nil).should == %(null)
    end
  end
end
