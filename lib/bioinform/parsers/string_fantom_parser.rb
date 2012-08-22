require 'bioinform/support'
require 'bioinform/parsers/string_parser'

module Bioinform
  class StringFantomParser < StringParser
    def row_pat
      /[\w\d]+ (#{number_pat} )*#{number_pat}/
    end
    def name_pat
      /NA (?<name>[\w.+:-]+)/
    end
    def header_pat
      /#{name_pat}\n[\w\d]+ A C G T\n/
    end
    
    def parse_name(scanner)
      name = scanner.scan(header_pat).match(header_pat)[:name]
    end
    
    def matrix_preprocess(matrix)
      matrix.split("\n").map{|line| line.split[1..-1].map(&:to_f)}
    end
  end
end