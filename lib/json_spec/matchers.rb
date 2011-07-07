require "json"
require "rspec"

RSpec::Matchers.define :be_json_eql do |expected_json|
  include JsonSpec::Helpers

  diffable

  match do |actual_json|
    @actual, @expected = scrub(actual_json, @path), [scrub(expected_json)]
    @actual == @expected.first
  end

  chain :at_path do |path|
    @path = path
  end

  chain :excluding do |*keys|
    excluded_keys.add(*keys.map(&:to_s))
  end

  chain :including do |*keys|
    excluded_keys.subtract(keys.map(&:to_s))
  end

  failure_message_for_should do
    message = "Expected equivalent JSON"
    message << %( at path "#{@path}") if @path
    message
  end

  def scrub(json, path = nil)
    ruby = path ? ruby_at_json_path(json, path) : parse_json_value(json)
    multiline(pretty_json_value(exclude_keys(ruby)))
  end

  def multiline(string)
    lines = string.lines.to_a
    lines.fill(nil, lines.size, 2).join("\n")
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

RSpec::Matchers.define :have_json_size do |expected_size|
  include JsonSpec::Helpers

  match do |json|
    ruby = @path ? ruby_at_json_path(json, @path) : parse_json_value(json)
    actual_size = ruby.is_a?(Enumerable) ? ruby.size : 1
    actual_size == expected_size
  end

  chain :at_path do |path|
    @path = path
  end

  failure_message_for_should do
    message = "Expected JSON value size of #{expected_size}"
    message << %( at path "#{@path}") if @path
    message
  end
end

RSpec::Matchers.define :have_json_path do |path|
  include JsonSpec::Helpers

  match do |json|
    begin
      ruby_at_json_path(json, path)
      true
    rescue JsonSpec::MissingPathError
      false
    end
  end

  failure_message_for_should do
    %(Expected JSON path "#{path}")
  end
end
