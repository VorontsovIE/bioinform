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
        PM::Parser.subclasses << subclass
      end
    end
    
    def initialize(input)
      @input = input
    end
    
    def parse
      raise ArgumentError  unless can_parse?
    end
    
    def can_parse?
      false
    end 
  end
end