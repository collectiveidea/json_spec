module JsonSpec
  module Memory
    def memory
      @memory ||= {}
    end

    def memorize(key, value)
      memory[key] = value
    end

    def remember(json)
      return json if memory.empty?
      json.gsub(/%\{(#{memory.keys.map{|k| Regexp.quote(k) }.join("|")})\}/){ memory[$1] }
    end

    def forget
      memory.clear
    end
  end
end
