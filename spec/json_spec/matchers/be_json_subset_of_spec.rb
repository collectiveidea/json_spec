require "spec_helper"

describe JsonSpec::Matchers::BeJsonSubsetOf do
  it 'matches empty json' do
    expect(%({})).to be_json_subset_of(%({}))
  end

  it "matches identical JSON" do
    expect(%({"json":"spec"})).to be_json_subset_of(%({"json":"spec"}))
  end

  it "matches differently-formatted JSON" do
    expect(%({"json": "spec"})).to be_json_subset_of(%({"json":"spec"}))
  end

  it "matches out-of-order hashes" do
    expect(%({"laser":"lemon","json":"spec"})).to be_json_subset_of(%({"json":"spec","laser":"lemon"}))
  end

  it "only works for JSON objects (i.e. hashes) compared against each other" do
    vals = [%(5), %("5"), %(false), %([5]), %({"json":5})]
    vals.each do |x|
      vals[0..-2].each do |y|
        expect{expect(x).not_to be_json_subset_of y}.to raise_error
      end
    end
  end

  it "matches at a path" do
    expect(%({"json":{"laser":"lemon"}})).to be_json_subset_of(%({"laser":"lemon"})).at_path("json")
  end

  it "matches a superset" do
    expect(%({"json":"spec"})).to be_json_subset_of(%({"laser":"lemon","json":"spec"}))
  end

  it "doesn't match a subset" do
    expect(%({"laser":"lemon","json":"spec"})).not_to be_json_subset_of(%({"json":"spec"}))
  end

  it "ignores excluded-by-default hash keys" do
    expect(JsonSpec.excluded_keys).not_to be_empty

    actual = expected = {"json" => "spec"}
    JsonSpec.excluded_keys.each{|k| actual[k] = k }
    expect(actual.to_json).to be_json_subset_of(expected.to_json)
  end

  it "ignores custom excluded hash keys" do
    JsonSpec.exclude_keys("ignore")
    expect(%({"json":"spec"})).to be_json_subset_of(%({"json":"spec","ignore":"please"}))
  end

  it "ignores nested, excluded hash keys" do
    JsonSpec.exclude_keys("ignore")
    expect(%({"json":"spec","please":{}})).to be_json_subset_of(%({"json":"spec","please":{"ignore":"this"}}))
  end

  it "ignores hash keys when included in the expected value" do
    JsonSpec.exclude_keys("ignore")
    expect(%({"json":"spec","ignore":"please"})).to be_json_subset_of(%({"json":"spec","ignore":"this"}))
  end

  it "doesn't match Ruby-equivalent, JSON-inequivalent values" do
    expect(%({"one":1})).not_to be_json_subset_of(%({"one":1.0}))
  end

  it "matches different looking, JSON-equivalent values" do
    expect(%({"ten":10.0})).to be_json_subset_of(%({"ten":1e+1}))
  end

  it "excludes extra hash keys per matcher" do
    JsonSpec.excluded_keys = %w(ignore)
    expect(%({"id":1,"json":"spec","ignore":"please"})).to be_json_subset_of(%({"id":2,"json":"spec","ignore":"this"})).excluding("id")
  end

  it "excludes extra hash keys given as symbols" do
    JsonSpec.excluded_keys = []
    expect(%({"id":1,"json":"spec"})).to be_json_subset_of(%({"id":2,"json":"spec"})).excluding(:id)
  end

  it "excludes multiple keys" do
    JsonSpec.excluded_keys = []
    expect(%({"id":1,"json":"spec"})).to be_json_subset_of(%({"id":2,"json":"different"})).excluding(:id, :json)
  end

  it "includes globally-excluded hash keys per matcher" do
    JsonSpec.excluded_keys = %w(id ignore)
    expect(%({"id":1,"json":"spec","ignore":"please"})).not_to be_json_subset_of(%({"id":2,"json":"spec","ignore":"this"})).including("id")
  end

  it "includes globally-included hash keys given as symbols" do
    JsonSpec.excluded_keys = %w(id)
    expect(%({"id":1,"json":"spec"})).not_to be_json_subset_of(%({"id":2,"json":"spec"})).including(:id)
  end

  it "includes multiple keys" do
    JsonSpec.excluded_keys = %w(id json)
    expect(%({"id":1,"json":"spec"})).not_to be_json_subset_of(%({"id":2,"json":"different"})).including(:id, :json)
  end

  it "provides a description message" do
    matcher = be_json_subset_of(%({"id":2,"json":"spec"}))
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq "be subset of JSON"
  end

  it "provides a description message with path" do
    matcher = be_json_subset_of(%({"laser":"lemon"})).at_path("json")
    matcher.matches?(%({"id":1,"json":{"laser":"lemon"}}))
    expect(matcher.description).to eq %(be subset of JSON at path "json")
  end

  it "raises an error when not given expected JSON" do
    expect{ expect(%({"id":1,"json":"spec"})).to be_json_subset_of }.to raise_error
  end

  it "matches file contents" do
    JsonSpec.directory = files_path
    expect(%({ "value" : "from_file" })).to be_json_subset_of.to_file("one.json")
  end
end
