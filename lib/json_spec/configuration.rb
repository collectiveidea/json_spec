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
      @excluded_keys = keys.map{|k| k.to_s }.uniq
    end

    def exclude_keys(*keys)
      self.excluded_keys = keys
    end

    def reset
      instance_variables.each{|iv| remove_instance_variable(iv) }
    end
  end
end
