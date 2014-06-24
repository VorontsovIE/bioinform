require_relative '../support'
require_relative '../errors'

module Bioinform
  class Parser
    def initialize(nucleotides_in: :columns)
      raise Error, 'Unknown value of `nucleotides_in` parameter'  unless [:columns, :rows].include?(nucleotides_in.to_sym)
      @nucleotides_in = nucleotides_in.to_sym
    end
    def parse!(input)
      matrix = (@nucleotides_in == :rows) ? input.transpose : input
      raise Error unless Parser.valid_matrix?(matrix)
      {matrix: matrix, name: nil}
    end

    def parse(input)
      parse!(input) rescue nil
    end

    module ClassMethods
      def choose(input)
        [ Parser.new(nucleotides_in: :columns), Parser.new(nucleotides_in: :rows), StringParser.new,
          Bioinform::MatrixParser.new(has_name: false), Bioinform::MatrixParser.new(has_name: true)
        ].find do |parser|
          result = parser.parse(input)
          result && valid_matrix?(result[:matrix])
        end
      end

      def valid_matrix?(matrix)
        matrix.is_a?(Array) &&
        ! matrix.empty? &&
        matrix.all?{|pos| pos.is_a?(Array)} &&
        matrix.all?{|pos| pos.size == 4} &&
        matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric)}}
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
