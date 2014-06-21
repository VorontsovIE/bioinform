require_relative '../support'
require_relative '../error'

module Bioinform
  class Parser
    def init_input(*input)
      if input.size == 1  # [ [1,2,3,4] ],  [  [[1,2,3,4],[5,6,7,8]] ]
        if input.first.is_a?(Array) && input.first.all?{|el| el.is_a? Numeric}  # [ [1,2,3,4] ]
          input
        else  # [  [[1,2,3,4],[5,6,7,8]] ]
          input.first
        end
      else #[ [1,2,3,4], [5,6,7,8] ], [   ]
        input
      end
    end

    def parse!(*input)
      matrix = Parser.transform_input(init_input(*input))
      raise Error unless Parser.valid_matrix?(matrix)
      {matrix: matrix, name: nil}
    end

    def parse(*input)
      parse!(*input) rescue nil
    end

    module ClassMethods
      def choose(input)
        [ Parser.new, StringParser.new,
          Bioinform::MatrixParser.new(has_name: false), Bioinform::MatrixParser.new(has_name: true),
          StringFantomParser.new, JasparParser.new
        ].find do |parser|
          result = parser.parse(input)
          result && valid_matrix?(result[:matrix])
        end
      end

      def parse!(*input)
        new.parse!(*input)
      end
      def parse(*input)
        new.parse(*input)
      end

      def valid_matrix?(matrix)
        matrix.is_a?(Array) &&
        ! matrix.empty? &&
        matrix.all?{|pos| pos.is_a?(Array)} &&
        matrix.all?{|pos| pos.size == 4} &&
        matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric)}}
      rescue
        false
      end

      def transform_input(input)
        need_tranpose?(input) ? input.transpose : input
      end

      # point whether matrix input positions(need not be transposed -- false) or letters(need -- true) as first index
      # [[1,3,5,7], [2,4,6,8]] --> false
      # [[1,2],[3,4],[5,6],[7,8]] --> true
      def need_tranpose?(input)
        (input.size == 4) && input.any?{|x| x.size != 4}
      end
    end

    extend ClassMethods
  end
end
