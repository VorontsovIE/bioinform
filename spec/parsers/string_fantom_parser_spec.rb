require 'spec_helper'
require 'bioinform/parsers/string_fantom_parser'

module Bioinform    
  describe StringFantomParser do
    good_cases = {
      'string in Fantom-format' => {input: "
          NA  motif_CTNCAG					
          P0	A	C	G	T	
          P1	0	1878368	0	0	
          P2	0	0	0	1878368	
          P3	469592	469592	469592	469592	
          P4	0	1878368	0	0	
          P5	1878368	0	0	0	
          P6	0	0	1878368	0",
          matrix: [[0.0, 1878368.0, 0.0, 0.0], 
                    [0.0, 0.0, 0.0, 1878368.0], 
                    [469592.0, 469592.0, 469592.0, 469592.0], 
                    [0.0, 1878368.0, 0.0, 0.0], 
                    [1878368.0, 0.0, 0.0, 0.0], 
                    [0.0, 0.0, 1878368.0, 0.0]] }      
    }
    
    bad_cases = { }
  
    parser_specs(StringFantomParser, good_cases, bad_cases)
  end
end