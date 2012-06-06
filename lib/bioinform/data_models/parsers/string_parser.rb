require 'bioinform/support'
require 'bioinform/data_models/parser'
require 'bioinform/data_models/parsers/array_parser'

module Bioinform
  class StringParser < PM::Parser    
    def number_pat
      '[+-]?\d+(\.\d+)?'
    end
    def row_pat 
      "(#{number_pat} )*#{number_pat}"
    end
    def name_pat
      '>? ?(?<name>[\w.+:-]+)'
    end
    def matrix_pat 
      "(?<matrix>(#{row_pat}\n)*#{row_pat})"
    end
    def header_pat
      "(#{name_pat}\n)?"
    end
    def pattern
      /\A#{header_pat}#{matrix_pat}\z/
    end
    
    # when matrix is extracted from the string it should be transformed to a matrix of numerics
    def matrix_preprocess(matrix)
      matrix.split("\n").map{|line| line.split.map(&:to_f)}
    end

    def parse_core
      case input
      when String      
        match = input.multiline_squish.match(pattern)
        raise ArgumentError  unless match
        matrix = matrix_preprocess( match[:matrix] )
        raise ArgumentError  unless matrix
        result = ArrayParser.new(matrix).parse
        match[:name]  ?  result.merge(name: match[:name])  :  result
      else
        raise ArgumentError
      end
    end
  end
end