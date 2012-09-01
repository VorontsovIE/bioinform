require 'spec_helper'
require 'bioinform/parsers/string_parser'

module Bioinform
  describe StringParser do

    describe '#each' do
      it 'should yield consequent results of #parse! while it returns result' do
        parser = StringParser.new("1 2 3 4\n5 6 7 8\n\n1 2 3 4\n1 2 3 4\nName\n4 3 2 1\n1 1 1 1\n0 0 0 0")
        expect{|b| parser.each(&b)}.to yield_successive_args({matrix:[[1,2,3,4],[5,6,7,8]], name:nil}, {matrix:[[1,2,3,4],[1,2,3,4]], name:nil}, {matrix:[[4,3,2,1],[1,1,1,1],[0,0,0,0]], name:'Name'} )
      end
      it 'should restart parser from the beginning each time' do
        parser = StringParser.new("1 2 3 4\n5 6 7 8\n\n1 2 3 4\n1 2 3 4\nName\n4 3 2 1\n1 1 1 1\n0 0 0 0")
        3.times do
          expect{|b| parser.each(&b)}.to yield_successive_args({matrix:[[1,2,3,4],[5,6,7,8]], name:nil}, {matrix:[[1,2,3,4],[1,2,3,4]], name:nil}, {matrix:[[4,3,2,1],[1,1,1,1],[0,0,0,0]], name:'Name'} )
        end
      end
    end
    
    context '::split' do
      it 'should be able to get a single PM' do
        StringParser.split("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12").should == [ {matrix: [[1,2,3,4],[5,6,7,8],[9,10,11,12]], name:nil} ]
      end
      
      it 'should be able to split several PMs separated with an empty line' do
        StringParser.split("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \n\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").should == [ {matrix:[[1,2,3,4],[5,6,7,8],[9,10,11,12]],name:nil}, {matrix:[[9,10,11,12],[1,2,3,4],[5,6,7,8]],name:nil} ]
      end
      
      it 'should be able to split several PMs separated with name' do
        StringParser.split("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").should == [ {matrix:[[1,2,3,4],[5,6,7,8],[9,10,11,12]],name:nil}, {matrix:[[9,10,11,12],[1,2,3,4],[5,6,7,8]],name:'Name'} ]
        
        StringParser.split("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \n\nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8\n\n\n").should == [ {matrix:[[1,2,3,4],[5,6,7,8],[9,10,11,12]],name:nil}, {matrix:[[9,10,11,12],[1,2,3,4],[5,6,7,8]],name:'Name'} ]
      end
    end
    
    context '::split_on_motifs' do
      it 'should be able to split string into PMs' do
        result = StringParser.split_on_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8")
        result.map{|pm| pm.matrix}.should == [  [[1,2,3,4],[5,6,7,8],[9,10,11,12]], [[9,10,11,12],[1,2,3,4],[5,6,7,8]]  ]
        result.map{|pm| pm.name}.should == [nil, 'Name']
      end
      it 'should create PMs by default' do
        result = StringParser.split_on_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8")
        result.each{|pm| pm.class.should == PM}
      end
      it 'should create PM subclass when it\'s specified' do
        result = StringParser.split_on_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nName\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8", PWM)
        result.each{|pm| pm.class.should == PWM} 
      end
    end
    
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