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
      expect{ parse_json("json_spec") }.to raise_error(MultiJson::DecodeError)
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
  
  context "load_json_file" do
    let(:files_root) { File.expand_path("../../../features/support/files", __FILE__) }
    
    it "should raise error when no directory set" do
      expect{ load_json("one.json") }.to raise_error(JsonSpec::MissingDirectoryError)
    end
  
    it "should return JSON when file exists" do
      File.exist?(files_root).should be_true
      JsonSpec.directory = files_root
      load_json("one.json").should == %({"value":"from_file"})
    end
    
    it "should not be affected by extra slash on directory" do
      JsonSpec.directory = files_root + "/"
      load_json("one.json").should == %({"value":"from_file"})
    end
    it "should raise error when file does not exist" do
      File.exist?(files_root).should be_true
      JsonSpec.directory = files_root
      expect{ load_json("none.json") }.to raise_error(JsonSpec::MissingFileError)
    end
    
    it "should raise error when it's a bad directory" do
      File.exist?(files_root).should be_true
      JsonSpec.directory = files_root + "_bad"
      expect{ load_json("one.json") }.to raise_error(JsonSpec::MissingFileError)
    end
    
    it "should work with nested files" do
      JsonSpec.directory = files_root
      load_json("project/one.json").should == %({"nested":"inside_folder"})
      load_json("project/version/one.json").should == %({"nested":"deeply"})
    end  
  end
end
