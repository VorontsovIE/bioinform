require 'bioinform/parsers/string_parser'

module Bioinform
  def self.separator_pat
    /\s*\n\s*/
  end

  def self.split_onto_motifs(input)
    parser = StringParser.new(input)
    motifs = []
    while parser.scanner.rest?
      motif = (parser.parse!  rescue nil)
      if motif
        motifs << motif
      else
        parser.scanner.scan(separator_pat) ? next : break
      end
    end
    motifs
  end
end
