require "json"
require "rspec"

RSpec::Matchers.define :be_json_eql do |*args|
  include JsonSpec::Helpers
  include JsonSpec::Exclusion

  @expected_json = args.first if args.size > 0

  diffable

  match do |actual_json|
    raise "Expected equivalent JSON not provided" if @expected_json.nil?
    @actual, @expected = scrub(actual_json, @path), [scrub(@expected_json)]
    @actual == @expected.first
  end

  chain :at_path do |path|
    @path = path
  end

  chain :excluding do |*keys|
    excluded_keys.merge(keys.map{|k| k.to_s })
  end

  chain :including do |*keys|
    excluded_keys.subtract(keys.map{|k| k.to_s })
  end
  
  chain :to_file do |relative_file_path|
    @expected_json = load_json(relative_file_path)
  end

  failure_message_for_should do
    message = "Expected equivalent JSON"
    message << %( at path "#{@path}") if @path
    message
  end

  failure_message_for_should_not do
    message = "Expected inequivalent JSON"
    message << %( at path "#{@path}") if @path
    message
  end

  def scrub(json, path = nil)
    generate_normalized_json(exclude_keys(parse_json(json, path))).chomp + "\n"
  end
end

RSpec::Matchers.define :include_json do |*args|
  include JsonSpec::Helpers
  include JsonSpec::Exclusion

  @expected_json = args.first if args.size > 0

  match do |actual_json|
    raise "Expected equivalent JSON not provided" if @expected_json.nil?
    
    actual = parse_json(actual_json, @path)
    expected = exclude_keys(parse_json(@expected_json))
    
    case actual
    when Hash then actual.values.map{|v| exclude_keys(v) }.include?(expected)
    when Array then actual.map{|e| exclude_keys(e) }.include?(expected)
    else false
    end
  end

  chain :at_path do |path|
    @path = path
  end

  chain :excluding do |*keys|
    excluded_keys.merge(*keys.map{|k| k.to_s })
  end

  chain :including do |*keys|
    excluded_keys.subtract(keys.map{|k| k.to_s })
  end
  
  chain :from_file do |relative_file_path|
    @expected_json = load_json(relative_file_path)
  end

  failure_message_for_should do
    message = "Expected included JSON"
    message << %( at path "#{@path}") if @path
    message
  end

  failure_message_for_should_not do
    message = "Expected excluded JSON"
    message << %( at path "#{@path}") if @path
    message
  end
end

RSpec::Matchers.define :have_json_path do |path|
  include JsonSpec::Helpers

  match do |json|
    begin
      parse_json(json, path)
      true
    rescue JsonSpec::MissingPathError
      false
    end
  end

  failure_message_for_should do
    %(Expected JSON path "#{path}")
  end

  failure_message_for_should_not do
    %(Expected no JSON path "#{path}")
  end
end

RSpec::Matchers.define :have_json_type do |klass|
  include JsonSpec::Helpers

  match do |json|
    @json = json
    actual.is_a?(klass)
  end

  chain :at_path do |path|
    @path = path
  end

  failure_message_for_should do
    message = "Expected JSON value type to be #{klass}, got #{actual.class}"
    message << %( at path "#{@path}") if @path
    message
  end

  failure_message_for_should_not do
    message = "Expected JSON value type to not be #{klass}, got #{actual.class}"
    message << %( at path "#{@path}") if @path
    message
  end

  def actual
    parse_json(@json, @path)
  end
end

RSpec::Matchers.define :have_json_size do |expected_size|
  include JsonSpec::Helpers

  match do |json|
    @json = json
    actual_size == expected_size
  end

  chain :at_path do |path|
    @path = path
  end

  failure_message_for_should do
    message = "Expected JSON value size to be #{expected_size}, got #{actual_size}"
    message << %( at path "#{@path}") if @path
    message
  end

  failure_message_for_should_not do
    message = "Expected JSON value size to not be #{expected_size}, got #{actual_size}"
    message << %( at path "#{@path}") if @path
    message
  end

  def actual_size
    ruby = parse_json(@json, @path)
    ruby.is_a?(Enumerable) ? ruby.size : 1
  end
end
