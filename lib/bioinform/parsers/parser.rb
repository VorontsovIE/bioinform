require 'bioinform/support'

module Bioinform
  class Parser
    attr_reader :input, :matrix
    
    def initialize(input)
      @input = input
    end
    
    def parse!
      inp = self.class.try_convert_to_array(input).map{|x| self.class.try_convert_to_array(x)}
      should_transpose = input.is_a?(Hash) || (inp.size == 4) && inp.same_by?(&:size) && !inp.all?{|x| x.size == 4}
      @matrix = should_transpose ? inp.transpose : inp
      parsing_result
    end
    
    def parse
      parse!  rescue {}
    end
      
    def parsing_result(options={})
      raise 'Parsing Error' unless matrix.is_a?(Array) && ! matrix.empty? && matrix.all?(&:is_a?.(Array)) && matrix.all?{|pos| pos.size == 4} && matrix.all?(&:all?.(&:is_a?.(Numeric)))
      options.merge(matrix: @matrix)
    end

    def self.array_from_acgt_hash(hsh)
      hsh = hsh.collect_hash{|key,value| [key.to_s.upcase, value] }
      raise 'some of hash keys A,C,G,T are missing or hash has excess keys' unless hsh.keys.sort == %w[A C G T]
      %w[A C G T].collect{|letter| hsh[letter] }
    end
    
    def self.try_convert_to_array(input)
      case input
      when Array
        input
      when Hash
        array_from_acgt_hash(input)
      else 
        raise TypeError, 'input of Bioinform::Parser::array_from_acgt_hash should be Array or Hash'
      end
    end
    
  end
end