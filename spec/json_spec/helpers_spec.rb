require "spec_helper"

describe JsonSpec::Helpers do
  include described_class

  context "parse_json" do
    it "parses JSON documents" do
      parse_json(%({"json":["spec"]})).should eq({"json" => ["spec"]})
    end

    it "parses JSON values" do
      parse_json(%("json_spec")).should eq "json_spec"
    end

    it "raises a parser error for invalid JSON" do
      expect{ parse_json("json_spec") }.to raise_error(MultiJson::DecodeError)
    end

    it "parses at a path if given" do
      json = %({"json":["spec"]})
      parse_json(json, "json").should eq ["spec"]
      parse_json(json, "json/0").should eq "spec"
    end

    it "raises an error for a missing path" do
      json = %({"json":["spec"]})
      %w(spec json/1).each do |path|
        expect{ parse_json(json, path) }.to raise_error(JsonSpec::MissingPath)
      end
    end

    it "parses at a numeric string path" do
      json = %({"1":"two"})
      parse_json(json, "1").should eq "two"
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
      normalize_json(%({"json":["spec"]})).should eq normalized.chomp
    end

    it "normalizes at a path" do
      normalize_json(%({"json":["spec"]}), "json/0").should eq %("spec")
    end

    it "accepts a JSON value" do
      normalize_json(%("json_spec")).should eq %("json_spec")
    end

    it "normalizes JSON values" do
      normalize_json(%(1e+1)).should eq %(10.0)
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
      generate_normalized_json({"json" => ["spec"]}).should eq normalized.chomp
    end

    it "generates a normalized JSON value" do
      generate_normalized_json(nil).should eq %(null)
    end
  end

  context "load_json_file" do
    it "raises an error when no directory is set" do
      expect{ load_json("one.json") }.to raise_error(JsonSpec::MissingDirectory)
    end

    it "returns JSON when the file exists" do
      JsonSpec.directory = files_path
      load_json("one.json").should eq %({"value":"from_file"})
    end

    it "ignores extra slashes" do
      JsonSpec.directory = "/#{files_path}/"
      load_json("one.json").should eq %({"value":"from_file"})
    end

    it "raises an error when the file doesn't exist" do
      JsonSpec.directory = files_path
      expect{ load_json("bogus.json") }.to raise_error(JsonSpec::MissingFile)
    end

    it "raises an error when the directory doesn't exist" do
      JsonSpec.directory = "#{files_path}_bogus"
      expect{ load_json("one.json") }.to raise_error(JsonSpec::MissingFile)
    end

    it "finds nested files" do
      JsonSpec.directory = files_path
      load_json("project/one.json").should eq %({"nested":"inside_folder"})
      load_json("project/version/one.json").should eq %({"nested":"deeply"})
    end
  end
end
