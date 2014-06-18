module Bioinform
  class CollectionParser
    attr_reader :parser, :input, :original_input
    def initialize(parser, input)
      @parser, @input, @original_input = parser, input, input
    end
    def parse!
      result = @parser.parse!(@input)
      @input = @parser.rest_input
      result
    end

    def parse
      parse! rescue nil
    end

    def each
      if block_given?
        scanner_reset
        yield parse
        while parser.rest_input
          yield parse
        end
      else
        self.to_enum(:each)
      end
    end

    include Enumerable
    alias_method :split, :to_a

    def split_on_motifs
      to_a.map{|el|
        if el.is_a?(PM)
          el
        else
          PM.new(matrix:el.matrix, name:el.name)
        end
      }
    end

    def scanner_reset
      @input = @original_input
    end
    private :scanner_reset
  end
end
