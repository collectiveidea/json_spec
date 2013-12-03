module JsonSpec
  module Exclusion
    extend self

    def excluding(*keys)
      excluded_keys.merge(keys.map(&:to_s))
      self
    end

    def including(*keys)
      excluded_keys.subtract(keys.map(&:to_s))
      self
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
end
