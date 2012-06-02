# It's a big question - how to make parser changeable for both input and output. E.g. how StringParser should treat PPM-s count

class PM
  class Parser
    attr_reader :input
    
    @subclasses ||= []
    class << self
      def subclasses
        @subclasses
      end  
      def inherited(subclass)
        @subclasses << subclass
      end
    end
    
    def initialize(input)
      @input = input
    end
    def parse
      #{matrix: [[]], name: 'Empty'}
      raise NotImplementedError, 'PM::Parser#parse should be redefined in subclasses'
    end
    def can_parse?(input)
      false
    end
  end
end

=begin
class PM
  module Parsers
    class ArrayParser < PM::Parser
    end
    
    class HashParser < PM::Parser
    end
    
    class RawStringParser < PM::Parser
    end
    
    class FantomParser < PM::Parser  
      parse_only_to :PCM
      def parse(input)
        { matrix: [[1,2,3,4],[4,5,6,3]] }
      end
    end
  end
end
=end


### PCM.new input, DefaultParser
### PCM.new input, FantomParser
### PCM.new input
### PPM.new input, DefaultParser # if DefaultParser.can_parse?(input) then PPM.new DefaultParser.new.parse(input)