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

    def split_on_motifs(pm_klass = PM)
      to_a.map{|el|
        if el.is_a?(pm_klass)
          el
        else
          pm_klass.new(el)
        end
      }
    end

    def scanner_reset
      @input = @original_input
    end
    private :scanner_reset
  end

  class Parser
    module SingleMotifParser
      # def self.included(base)
      #   base.class_eval { extend ClassMethods }
      #   include Enumerable
      #   alias_method :split, :to_a
      # end
      module ClassMethods
      #   def split_on_motifs(input, pm_klass = PM)
      #     [ input.is_a?(pm_klass) ? self : pm_klass.new(input, self) ]
      #   end
      end
      # def each
      #   if block_given?
      #     yield self
      #   else
      #     self.to_enum(:each)
      #   end
      # end
    end
    # include SingleMotifParser

    module MultipleMotifsParser
      # def self.included(base)
      #   base.class_eval { extend ClassMethods }
      #   include Enumerable
      #   alias_method :split, :to_a
      # end
      module ClassMethods
      #   def split_on_motifs(input, pm_klass = PM)
      #     split(input).map{|el| el.is_a?(pm_klass) ? el : pm_klass.new(el)}
      #   end
      #   def split(input)
      #     CollectionParser.new(self.new, input).split
      #   end
      #   private :split
      end

      # def each(&block)
      #   CollectionParser.new(self, input).each(&block)
      # end
    end
  end
end