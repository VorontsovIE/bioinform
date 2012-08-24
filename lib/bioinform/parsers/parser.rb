require 'bioinform/support'

module Bioinform
  class Parser
    attr_reader :input, :matrix
    
    def initialize(input)
      @input = input
    end
    
    def parse!
      inp = input
      transpose =  inp.is_a?(Hash)
      inp = ClassMethods.try_convert_to_array(inp)
      inp.map!{|x| ClassMethods.try_convert_to_array(x)}
      transpose = true  if (not inp.all?{|x| x.size == 4}) && inp.size == 4 && inp.same_by?(&:size)
      @matrix = transpose ? inp.transpose : inp
      result
    end
    
    def parse
      parse!  rescue {}
    end
      
    def result(options={})
      raise 'Parsing Error' unless matrix.is_a?(Array) && ! matrix.empty? && matrix.all?(&:is_a?.(Array)) && matrix.all?{|pos| pos.size == 4} && matrix.all?(&:all?.(&:is_a?.(Numeric)))
      options.merge(matrix: @matrix)
    end
    
    class ClassMethods
      def self.array_from_acgt_hash(hsh)
        hsh = hsh.collect_hash{|key,value| [key.to_s.upcase, value] }
        raise 'some of hash keys A,C,G,T are missing or hash has excess keys' unless hsh.keys.sort == %w[A C G T]
        %w[A C G T].collect{|letter| hsh[letter] }
      end
      def self.try_convert_to_array(inp)
        return inp  if inp.is_a? Array
        array_from_acgt_hash(inp)
      end
    end
  end
end