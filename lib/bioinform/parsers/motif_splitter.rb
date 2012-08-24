require 'bioinform/parsers/string_parser'

module Bioinform
  def self.split_onto_motifs(input)
    parser = StringParser.new(input)
    motifs = []
    motifs << parser.parse!  while parser.scanner.rest?
    motifs
  end
end
