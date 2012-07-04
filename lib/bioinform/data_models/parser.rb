require 'bioinform/support'
require 'bioinform/data_models/pm'

module Bioinform
  class Parser
    attr_reader :input
    
    @subclasses ||= []
    class << self
      def subclasses
        @subclasses
      end  
      def inherited(subclass)
        Parser.subclasses << subclass
      end
    end
    
    def initialize(input)
      @input = input
    end
    
    def parse_core
      raise NotImplemented
    end
    
      
    def parse
      parse_core
    end
    
    def can_parse?
      parse_core
      true
    rescue
      false
    end
  end
end