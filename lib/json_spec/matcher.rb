require "json"
require "rspec"

RSpec::Matchers.define :be_json_eql do |expected_json|
  diffable

  match do |actual_json|
    @actual = scrub(actual_json)
    @expected = [scrub(expected_json)]
    @actual == @expected.first
  end

  chain :excluding do |*keys|
    excluded_keys.add(*keys)
  end

  chain :including do |*keys|
    excluded_keys.subtract(keys)
  end

  failure_message_for_should do
    "expected equivalent JSON"
  end

  def scrub(value)
    ruby = value.is_a?(String) ? JSON.parse(value) : value
    JSON.pretty_generate(exclude_keys(ruby))
  end

  def exclude_keys(ruby)
    case ruby
    when Hash
      ruby.sort.inject({}) do |hash, (key, value)|
        hash[key] = exclude_keys(value) unless exclude_key?(key)
        hash
      end
    when Array
      ruby.map{|v| exclude_keys(v) }
    else ruby
    end
  end

  def exclude_key?(key)
    excluded_keys.include?(key)
  end

  def excluded_keys
    @excluded_keys ||= Set.new(JsonSpec.excluded_keys)
  end
end
