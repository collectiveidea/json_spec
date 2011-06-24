require "set"

module JsonSpec
  module Configuration
    DEFAULT_EXCLUDED_KEYS = %w(id created_at updated_at)

    def configure(&block)
      instance_eval(&block)
    end

    def excluded_keys
      @excluded_keys ||= DEFAULT_EXCLUDED_KEYS
    end

    def excluded_keys=(keys)
      @excluded_keys = keys.map(&:to_s).uniq
    end

    def exclude_keys(*keys)
      self.excluded_keys = keys
    end
  end
end
