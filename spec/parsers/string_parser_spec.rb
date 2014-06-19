require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/string_parser'

module Bioinform
  describe StringParser do

    describe '#each' do
      it 'should yield consequent results of #parse! while it returns result' do
        parser = CollectionParser.new(StringParser.new, "1 2 3 4\n5 6 7 8\n\n1 2 3 4\n1 2 3 4\nName\n4 3 2 1\n1 1 1 1\n0 0 0 0")
        expect{|b| parser.each(&b)}.to yield_successive_args(OpenStruct.new(matrix:[[1,2,3,4],[5,6,7,8]], name:nil),
                                                             OpenStruct.new(matrix:[[1,2,3,4],[1,2,3,4]], name:nil),
                                                             OpenStruct.new(matrix:[[4,3,2,1],[1,1,1,1],[0,0,0,0]], name:'Name') )
      end
      it 'should restart parser from the beginning each time' do
        parser = CollectionParser.new(StringParser.new, "1 2 3 4\n5 6 7 8\n\n1 2 3 4\n1 2 3 4\nName\n4 3 2 1\n1 1 1 1\n0 0 0 0")
        3.times do
          expect{|b| parser.each(&b)}.to yield_successive_args(OpenStruct.new(matrix:[[1,2,3,4],[5,6,7,8]], name:nil),
                                                               OpenStruct.new(matrix:[[1,2,3,4],[1,2,3,4]], name:nil),
                                                               OpenStruct.new(matrix:[[4,3,2,1],[1,1,1,1],[0,0,0,0]], name:'Name') )
        end
      end
    end

    context '::split_on_motifs' do ########################3
      it 'should be able to get a single PM' do
        CollectionParser.new(StringParser.new, "1 2 3 4 \n 5 6 7 8").split_on_motifs.should == [ Fabricate(:pm_unnamed) ]
      end
      it 'should be able to split several PMs separated with an empty line' do
        CollectionParser.new(StringParser.new, "1 2 3 4 \n 5 6 7 8 \n\n 15 16 17 18 \n 11 21 31 41").split_on_motifs.should ==
                                                                [ Fabricate(:pm_first, name: nil), Fabricate(:pm_second, name: nil) ]
      end
      it 'should be able to split several PMs separated with name' do
        CollectionParser.new(StringParser.new, "1 2 3 4 \n 5 6 7 8 \nPM_second\n 15 16 17 18 \n 11 21 31 41").split_on_motifs.should ==
                                                                [ Fabricate(:pm_first, name: nil), Fabricate(:pm_second) ]
      end
      it 'should be able to split several PMs separated with both name and empty line' do
        CollectionParser.new(StringParser.new, "PM_first\n1 2 3 4 \n 5 6 7 8 \n\nPM_second\n 15 16 17 18 \n 11 21 31 41\n\n\n").split_on_motifs.should ==
                                                                [ Fabricate(:pm_first), Fabricate(:pm_second) ]
      end
      it 'should create PMs by default' do
        result = CollectionParser.new(StringParser.new, "1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").split_on_motifs
        result.each{|pm| pm.class.should == PM}
      end
    end

    good_cases = {
      'Nx4 string' => {input: "1 2 3 4\n5 6 7 8",  result: Fabricate(:pm_unnamed) },
      '4xN string' => {input: "1 5\n2 6\n3 7\n 4 8",  result: Fabricate(:pm_unnamed) },
      'string with name' => {input: "PM_name\n1 5\n2 6\n3 7\n 4 8",  result: Fabricate(:pm) },
      'string with name (with introduction sign)' => {input: ">\t PM_name\n1 5\n2 6\n3 7\n 4 8",  result: Fabricate(:pm) },
      'string with name (with special characters)' => {input: "Testmatrix_first:subname+sub-subname\n1 5\n2 6\n3 7\n 4 8",
                                                       result: Fabricate(:pm, name: 'Testmatrix_first:subname+sub-subname') },
      'string with float numerics' => {input: "1.23 4.56 7.8 9.0\n9 -8.7 6.54 -3210",  result: Fabricate(:pm_with_floats) },
      'string with exponents' => {input: "123e-2 0.456e+1 7.8 9.0\n9 -87000000000E-10 6.54 -3.210e3",  result: Fabricate(:pm_with_floats) },
      'string with multiple spaces and tabs' => {input: "1 \t\t 2 3 4\n 5 6   7 8",  result: Fabricate(:pm_unnamed) },
      'string with preceeding and terminating newlines' => {input: "\n\n\t 1 2 3 4\n5 6 7 8  \n\t\n",  result: Fabricate(:pm_unnamed) },
      'string with windows crlf' => {input: "1 2 3 4\r\n5 6 7 8",  result: Fabricate(:pm_unnamed) },
    }

    bad_cases = {
      'string with non-numeric input' =>  {input: "1.23 4.56 78aaa 9.0\n9 -8.7 6.54 -3210" },
      'string with empty exponent sign' => {input: "1.23 4.56 7.8 9.0\n 9e -8.7 6.54 3210" }
    }

    parser_specs(StringParser, good_cases, bad_cases)
  end
end
