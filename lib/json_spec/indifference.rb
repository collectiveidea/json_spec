module JsonSpec
  module Indifference
    extend self

    def toggle_indifference( toggle )
      @indifferent = !!toggle
    end

    def indifferize(ruby)
      return ruby unless @indifferent

      case ruby
      when Hash
        ruby.sort.inject({}) do |hash, (key, value)|
          hash[key] = indifferize(value)
          hash
        end
      when Array
        ruby.map{|v| indifferize(v) }.sort_by{|v| generate_normalized_json(v) }
      else ruby
      end
    end

  end
end
