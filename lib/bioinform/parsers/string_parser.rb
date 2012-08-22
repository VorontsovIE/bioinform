require 'strscan'
require 'bioinform/support'
require 'bioinform/parsers/parser'

module Bioinform  
  class StringParser < Parser
    def number_pat
      /[+-]?\d+(\.\d+)?([eE][+-]?\d{1,3})?/
    end
    def row_pat 
      /(#{number_pat} )*#{number_pat}/
    end
    def name_pat
      /(>\s*)?(?<name>\S+)/
    end
    def matrix_pat 
      /(?<matrix>(#{row_pat}\n)*#{row_pat})/
    end
    
    def pattern
      /\A#{header_pat}#{matrix_pat}\z/
    end
    
    # when matrix is extracted from the string it should be transformed to a matrix of numerics
    def matrix_preprocess(matrix)
      matrix.split("\n").map{|line| line.split.map(&:to_f)}
    end
    
    def parse_name(scanner)
      unless scanner.check(number_pat)
        scanner.scan(/>\s*/)
        name = scanner.scan(/\S+/)
        scanner.scan(/\n/)
      end
      name
    end

    def parse
      case input
      when String
        scanner = StringScanner.new(input.multiline_squish)
        
        #name = scanner.scan(header_pat)
        #name = name.match(header_pat)[:name]
        name = parse_name(scanner)
        
        matrix = scanner.scan(matrix_pat)
        raise ArgumentError unless matrix

        matrix = matrix_preprocess( matrix )
        result = Parser.new(matrix).parse
        raise ArgumentError unless result && !result.empty?
        result.merge(name: name)
      else
        raise ArgumentError
      end
    rescue
      {}
    end
    
=begin
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
=end
 
  end
end