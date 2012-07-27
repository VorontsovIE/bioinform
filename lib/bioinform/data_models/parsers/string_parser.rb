require 'bioinform/support'
require 'bioinform/data_models/parsers/parser'

module Bioinform  
  class StringParser < Parser
    def number_pat
      '[+-]?\d+(\.\d+)?([eE][+-]?\d{1,3})?'
    end
    def row_pat 
      "(#{number_pat} )*#{number_pat}"
    end
    def name_pat
      '(>\s*)?(?<name>\S+)'
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

    def parse
      case input
      when String
        match = input.multiline_squish.match(pattern)
        raise ArgumentError  unless match
        matrix = matrix_preprocess( match[:matrix] )
        raise ArgumentError  unless matrix
        Parser.new(matrix).parse.merge(name: match[:name])
      else
        raise ArgumentError
      end
    rescue
      {}
    end
  end
end