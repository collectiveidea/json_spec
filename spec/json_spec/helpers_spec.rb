require "spec_helper"

describe JsonSpec::Helpers do
  include described_class

  context "parse_json_value" do
    it "parses JSON documents" do
      parse_json_value(%({"json":["spec"]})).should == {"json" => ["spec"]}
    end

    it "parses JSON values" do
      parse_json_value(%("json_spec")).should == "json_spec"
    end

    it "raises a parser error for invalid JSON" do
      expect{ parse_json_value("json_spec") }.to raise_error(JSON::ParserError)
    end
  end

  context "json_path_to_keys" do
    it "splits on slashes" do
      json_path_to_keys("json/spec").should == ["json", "spec"]
    end

    it "converts digits to integers" do
      json_path_to_keys("json/spec/1/2/3").should == ["json", "spec", 1, 2, 3]
    end

    it "ignores leading and trailing slashes" do
      json_path_to_keys("/json/spec/").should == ["json", "spec"]
    end
  end

  context "ruby_at_json_path" do
    let(:json){ %({"json":["spec"]}) }

    it "parses JSON at a path" do
      ruby_at_json_path(json, "json").should == ["spec"]
      ruby_at_json_path(json, "json/0").should == "spec"
    end

    it "raises an error for a missing path" do
      %w(spec json/1 json/0/0).each do |path|
        expect{ ruby_at_json_path(json, path).to raise_error(JsonSpec::MissingPathError) }
      end
    end
  end

  context "pretty_json_value" do
    it "formats a hash" do
      pretty = <<-JSON
{
  "json": "spec"
}
      JSON
      pretty_json_value({"json" => "spec"}).should == pretty.chomp
    end

    it "formats an array" do
      pretty = <<-JSON
[
  "json",
  "spec"
]
      JSON
      pretty_json_value(["json", "spec"]).should == pretty.chomp
    end

    it "formats nested structures" do
      pretty = <<-JSON
{
  "json": [
    "spec"
  ]
}
      JSON
      pretty_json_value({"json" => ["spec"]}).should == pretty.chomp
    end

    it "formats a string" do
      pretty_json_value("json_spec").should == %("json_spec")
    end

    it "formats an integer" do
      pretty_json_value(10).should == %(10)
    end

    it "formats a float" do
      pretty_json_value(10.0).should == %(10.0)
    end

    it "formats true" do
      pretty_json_value(true).should == %(true)
    end

    it "formats false" do
      pretty_json_value(false).should == %(false)
    end

    it "formats nil" do
      pretty_json_value(nil).should == %(null)
    end
  end

  context "json_at_path" do
    it "formats inline JSON" do
      json = %({"json":["spec"]})
      array = <<-JSON
[
  "spec"
]
      JSON
      json_at_path(json, "json").should == array.chomp
      json_at_path(json, "json/0").should == %("spec")
    end
  end
end
