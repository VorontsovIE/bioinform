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
      def valid_matrix?(matrix)
        matrix.is_a?(Array) &&
        ! matrix.empty? &&
        matrix.all?{|pos| pos.is_a?(Array)} &&
        matrix.all?{|pos| pos.size == 4} &&
        matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric)}}
      end
    end

    extend ClassMethods
  end
end
