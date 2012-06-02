require 'bioinform/data_models/pm'

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