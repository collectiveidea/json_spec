module JsonSpec
  module Memory
    def memory
      @memory ||= {}
    end

    def memorize(key, value)
      memory[key.to_sym] = value
    end

    def remember(json)
      (memory.empty? or json.is_a?(Numeric)) ? json : json % memory
    end

    def forget
      memory.clear
    end
  end
end
