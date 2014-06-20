require 'strscan'
require_relative '../support'
require_relative 'parser'
require_relative 'motif_splitter'
require_relative 'matrix_parser'

module Bioinform
  class StringParser < Parser
    def parse!(input)
      raise ArgumentError, 'StringParser should be initialized with a String'  unless input.is_a?(String)
      @input = input
      scanner_reset
      # fix_nucleotides_number is false because we don't know yet where
      # nucleotides are: in rows or in columns we do this check here in
      # Parser.transform_input, thus don't want to raise before normalization
      motif_data = MatrixParser.new(with_name: nil, fix_nucleotides_number: false).parse!(@motifs.shift)
      matrix = Parser.transform_input(motif_data[:matrix])
      raise InvalidMatrix unless Parser.valid_matrix?(matrix)
      {matrix: matrix, name: motif_data[:name]}
    end

    def scanner_reset
      @motifs = MotifSplitter.new.split(@input)
    end

    def rest_input
      @motifs.empty? ? nil : @motifs.join("\n\n")
    end
  end
end
