require 'spec_helper'
require 'bioinform/data_models/string_parser'

module Bioinform
  describe StringParser do
    good_cases = {
      'Nx4 string' => {input: "1 2 3 4\n5 6 7 8", 
                      matrix: [[1,2,3,4],[5,6,7,8]] },
                      
      '4xN string' => {input: "1 5\n2 6\n3 7\n 4 8", 
                      matrix: [[1,2,3,4],[5,6,7,8]] },
                      
      'string with name' => {input: "TestMatrix\n1 5\n2 6\n3 7\n 4 8", 
                            matrix: [[1,2,3,4],[5,6,7,8]], name: 'TestMatrix' },
                            
      'string with name (with introduction sign)' => {input: ">\t TestMatrix\n1 5\n2 6\n3 7\n 4 8",
                                                      matrix: [[1,2,3,4],[5,6,7,8]],
                                                      name: 'TestMatrix' },
                                                      
      'string with name (with special characters)' => {input: "Testmatrix_first:subname+sub-subname\n1 5\n2 6\n3 7\n 4 8", 
                            matrix: [[1,2,3,4],[5,6,7,8]], name: 'Testmatrix_first:subname+sub-subname' },

      'string with float numerics' => {input: "1.23 4.56 7.8 9.0\n9 -8.7 6.54 -3210",
                                      matrix: [[1.23, 4.56, 7.8, 9.0], [9, -8.7, 6.54, -3210]]},
      
      'string with exponents' => {input: "123e-2 0.456e+1 7.8 9.0\n9 -87000000000E-10 6.54 -3.210e3",
                                  matrix: [[1.23, 4.56, 7.8, 9.0], [9, -8.7, 6.54, -3210]]},

      'string with multiple spaces and tabs' => {input: "1 \t\t 2 3 4\n 5 6   7 8", 
                                                matrix: [[1,2,3,4],[5,6,7,8]] },
      
      'string with preceeding and terminating newlines' => {input: "\n\n\t 1 2 3 4\n5 6 7 8  \n\t\n", 
                      matrix: [[1,2,3,4],[5,6,7,8]] },
      
      'string with windows crlf' => {input: "1 2 3 4\r\n5 6 7 8",
                      matrix: [[1,2,3,4],[5,6,7,8]] }      
    }
    
    bad_cases = {
      'string with non-numeric input' =>  {input: "1.23 4.56 78aaa 9.0\n9 -8.7 6.54 -3210" },
      'string with empty exponent sign' => {input: "1.23 4.56 7.8 9.0\n 9e -8.7 6.54 3210" }
    }
  
    parser_specs(StringParser, good_cases, bad_cases)
  end
end