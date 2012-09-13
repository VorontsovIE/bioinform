require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/string_fantom_parser'

module Bioinform
  describe StringFantomParser do
    describe '#split_on_motifs' do
      it 'should be able to parse several motifs' do
        input = <<-EOS
//
NA  motif_1
P0	A	C	G	T
P1	0	1	2	3
P2	4	5	6	7
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
P2	6 7 8 9
        EOS
        StringFantomParser.split_on_motifs(input).should == [ PM.new(matrix: [[0,1,2,3],[4,5,6,7]], name: 'motif_1'),
                                                    PM.new(matrix: [[1,2,3,4],[5,6,7,8],[9,10,11,12]], name: 'motif_2'),
                                                    PM.new(matrix: [[2,3,4,5],[6,7,8,9]], name: 'motif_3') ]
      end
    end

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
        matrix: [ [0.0, 1878368.0, 0.0, 0.0],
                  [0.0, 0.0, 0.0, 1878368.0],
                  [469592.0, 469592.0, 469592.0, 469592.0],
                  [0.0, 1878368.0, 0.0, 0.0],
                  [1878368.0, 0.0, 0.0, 0.0],
                  [0.0, 0.0, 1878368.0, 0.0]],
        name: 'motif_CTNCAG'
      },
      
      'motif with additional rows' => {input: "
      NA  motif_1
      P0	A C G T S P
      P1	0 1 2 3 5 10
      P2	4 5 6 7 5 11",
      matrix: [[0,1,2,3],[4,5,6,7]],
      name: 'motif_1'}
    }

    bad_cases = { }

    parser_specs(StringFantomParser, good_cases, bad_cases)
  end
end