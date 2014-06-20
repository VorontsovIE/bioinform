require_relative '../support'
require_relative 'string_parser'

module Bioinform
  class StringFantomParser < Parser
    def parse!(input)
      raise ArgumentError, 'StringParser should be initialized with a String'  unless input.is_a?(String)
      @input = input
      scanner_reset
      parser = MatrixParser.new(has_name: true, name_pattern: /^NA\s+(?<name>.+)$/, has_header_row: true, has_header_column: true, nucleotide_in: :columns, reduce_to_n_nucleotides: 4)
      motif_data = parser.parse!(@motifs.shift)
      matrix = Parser.transform_input(motif_data[:matrix])
      raise InvalidMatrix unless Parser.valid_matrix?(matrix)
      {matrix: matrix, name: motif_data[:name]}
    end

    def scanner_reset
      @motifs = @input.split(/^\s*\/\/\s*$/).map(&:strip).reject(&:empty?)
    end

    def rest_input
      @motifs.empty? ? nil : @motifs.join("\n" + '//' + "\n")
    end
  end
end
