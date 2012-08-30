require 'bioinform/support'

module Bioinform
  class Parser
    attr_reader :input, :matrix
    
    def initialize(input)
      @input = input
    end
    
    def parse!
      @matrix = self.class.transform_input(input)
      raise 'Parsing Error' unless self.class.valid_matrix?(matrix)
      {matrix: matrix}
    end
    
    def parse
      parse! rescue nil
    end

    def self.valid_matrix?(matrix)
      matrix.is_a?(Array) && ! matrix.empty? && matrix.all?(&:is_a?.(Array)) && matrix.all?{|pos| pos.size == 4} && matrix.all?(&:all?.(&:is_a?.(Numeric)))
    end
    
    # {A: 1, C: 2, G: 3, T: 4}  -->  [1,2,3,4]
    # {A: [1,2], C: [3,4], G: [5,6], T: [7,8]}  --> [[1,3,5,7],[2,4,6,8]] ( == [[1,2], [3,4], [5,6], [7,8]].transpose)
    def self.array_from_acgt_hash(hsh)
      hsh = normalize_hash_keys(hsh)
      raise 'some of hash keys A,C,G,T are missing or hash has excess keys' unless hsh.keys.sort == [:A,:C,:G,:T]
      result = [:A,:C,:G,:T].collect{|letter| hsh[letter] }
      result.all?{|el| el.is_a?(Array)} ? result.transpose : result
    end
    
    # {a: 1, C: 2, 'g' => 3, 'T' => 4} --> {A: 1, C: 2, G: 3, T: 4}
    def self.normalize_hash_keys(hsh)
      hsh.collect_hash{|key,value| [key.to_s.upcase.to_sym, value] }
    end
    
    def self.try_convert_to_array(input)
      case input
      when Array then input
      when Hash then array_from_acgt_hash(input)
      else raise TypeError, 'input of Bioinform::Parser::array_from_acgt_hash should be Array or Hash'
      end
    end
    
    def self.transform_input(input)
      result = try_convert_to_array(input).map{|el| try_convert_to_array(el)}
      need_tranpose?(result) ? result.transpose : result
    end
    
    # point whether matrix have positions(need not be transposed -- false) or letters(need -- true) as first index
    # [[1,3,5,7], [2,4,6,8]] --> false
    # [[1,2],[3,4],[5,6],[7,8]] --> true
    def self.need_tranpose?(input)
      (input.size == 4) && input.any?{|x| x.size != 4}
    end
    
  end
end