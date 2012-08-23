require 'bioinform/support'
require 'bioinform/parsers/string_parser'

module Bioinform
  class StringFantomParser < StringParser
    def header_pat
      /NA (?<name>[\w.+:-]+)\n[\w\d]+ A C G T\n/
    end
    
    def row_pat
      /[\w\d]+ (?<row>(#{number_pat} )*#{number_pat})/
    end
  end
end