require_relative '../spec_helper'
require 'bioinform/parsers/string_parser'

module Bioinform
  describe StringParser do
    good_cases = {
      'Nx4 string' => {input: "1 2 3 4\n5 6 7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      '4xN string' => {input: "1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with name' => {input: "PM_name\n1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'} },
      'string with name (with introduction sign)' => {input: ">\t PM_name\n1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'} },
      'string with name (with special characters)' => {input: "Testmatrix_first:subname+sub-subname\n1 5\n2 6\n3 7\n 4 8",
                                                       result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'Testmatrix_first:subname+sub-subname'} },
      'string with float numerics' => {input: "1.23 4.56 7.8 9.0\n9 -8.7 6.54 -3210",  result: {matrix: [[1.23, 4.56, 7.8, 9.0],[9, -8.7, 6.54, -3210]], name: nil} },
      'string with exponents' => {input: "123e-2 0.456e+1 7.8 9.0\n9 -87000000000E-10 6.54 -3.210e3",  result: {matrix: [[1.23, 4.56, 7.8, 9.0],[9, -8.7, 6.54, -3210]], name: nil} },
      'string with multiple spaces and tabs' => {input: "1 \t\t 2 3 4\n 5 6   7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with preceeding and terminating newlines' => {input: "\n\n\t 1 2 3 4\n5 6 7 8  \n\t\n", result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with windows crlf' => {input: "1 2 3 4\r\n5 6 7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
    }

    bad_cases = {
      'string with non-numeric input' =>  {input: "1.23 4.56 78aaa 9.0\n9 -8.7 6.54 -3210" },
      'string with empty exponent sign' => {input: "1.23 4.56 7.8 9.0\n 9e -8.7 6.54 3210" }
    }

    parser_specs(StringParser.new, good_cases, bad_cases)
  end
end
