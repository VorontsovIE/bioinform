require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/string_fantom_parser'

module Bioinform
  describe StringFantomParser do
    describe 'CollectionParser#to_a' do
      it 'should be able to parse several motifs' do
        input = "
//
NA  motif_1
P0	A	C	G	T
P1	0 1	2	3
P2	4 5	6	7
//
//
NA  motif_2
P0	A	C	G	T
P1  1 2 3 4
P2  5 6 7 8
P3  9 10 11 12
//
NA  motif_3
P0	A	C	G	T
P1	2 3	4 5
P2	6 7 8 9"
        CollectionParser.new(StringFantomParser.new, input).to_a.should == [  OpenStruct.new(matrix: [[0,1,2,3],[4,5,6,7]], name: 'motif_1'),
                                                                              OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8],[9,10,11,12]], name: 'motif_2'),
                                                                              OpenStruct.new(matrix: [[2,3,4,5],[6,7,8,9]], name: 'motif_3') ]
      end
    end

    good_cases = {
      'string in Fantom-format' => {input: "
        NA  PM_name
        P0	A	C	G	T
        P1	1	2	3 4
        P2	5	6	7 8",
        result: OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name')
      },

      'motif with additional rows' => {input: "
        NA  PM_name
        P0	A C G T S P
        P1	1 2 3 4 5 10
        P2	5 6 7 8 5 11",
        result: OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name')
      },

      'string with more than 10 positions(2-digit row numbers)' => {input: "
        NA  PM_name
        P0	A	C	G	T
        P1	1	2	3	4
        P2	5	6	7	8
        P3	1	2	3	4
        P4	5	6	7	8
        P5	1	2	3	4
        P6	5	6	7	8
        P7	1	2	3	4
        P8	5	6	7	8
        P9	1	2	3	4
        P10	5	6	7	8
        P11	1	2	3	4
        P12	5	6	7	8",
        result: OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8]] * 6, name: 'PM_name')
      }
    }

    bad_cases = { }

    parser_specs(StringFantomParser, good_cases, bad_cases)
  end
end
