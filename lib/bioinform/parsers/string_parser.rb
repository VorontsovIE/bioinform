require 'strscan'
require 'bioinform/support'
require 'bioinform/parsers/parser'

module Bioinform  
  class StringParser < Parser
    attr_reader :scanner
    def initialize(input)
      super
      @scanner = StringScanner.new(input.multiline_squish)
    end
  
    def number_pat
      /[+-]?\d+(\.\d+)?([eE][+-]?\d{1,3})?/
    end
    
    def header_pat
      />?\s*(?<name>\S+)\n/
    end
    
    def row_pat 
      /(?<row>(#{number_pat} )*#{number_pat})/
    end
    
    def parse_name
      match = scanner.advanced_scan(header_pat)
      match && match[:name]
    end
    
    def scan_row
      match = scanner.advanced_scan(row_pat)
      match && match[:row]
    end
    
    def split_row(row_string)
      row_string.split.map(&:to_f)
    end
    
    def parse_matrix
      matrix = []
      while row_string = scan_row
        matrix << split_row(row_string)
        scanner.scan(/\n/)
      end
      matrix
    end

    def parse!
      raise ArgumentError  unless input.is_a?(String)
      name = parse_name
      matrix = parse_matrix
      Parser.new(matrix).parse! .merge(name: name)
    end
  end
end