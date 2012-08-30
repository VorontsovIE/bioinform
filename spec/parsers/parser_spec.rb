require 'spec_helper'
require 'bioinform/parsers/parser'

module Bioinform
  describe Parser do
    context '::normalize_hash_keys' do
      it 'should convert both symbolic and string keys, in both upcase and downcase to symbolic upcases' do
        Parser.normalize_hash_keys( {a: 1, C: 2, 'g' => 3, 'T' => 4} ).should == {A: 1, C: 2, G: 3, T: 4}
      end
    end
    
    context '::need_transpose?' do
      it 'should point whether matrix have positions(need not be transposed -- false) or letters(true) as first index' do
        Parser.need_tranpose?([[1,3,5,7], [2,4,6,8]]).should be_false
        Parser.need_tranpose?([[1,2],[3,4],[5,6],[7,8]]).should be_true
      end
    end
    context '::array_from_acgt_hash' do
      it 'should convert hash of arrays to a transposed array of arrays' do
        input = {A: [1,2,3], C: [2,3,4], G: [3,4,5], T: [4,5,6]}
        Parser.array_from_acgt_hash(input).should == [[1,2,3], [2,3,4], [3,4,5], [4,5,6]].transpose
      end
      it 'should convert hash of numbers to an array of numbers' do
        input = {A: 1, C: 2, G: 3, T: 4}
        Parser.array_from_acgt_hash(input).should == [1,2,3,4]
      end
      it 'should process both symbolic and string keys, in both upcase and downcase' do
        input_normal_keys = {A: 1, C: 2, G: 3, T: 4}
        input_different_keys = {:A => 1, :c => 2, 'g' => 3, 'T' => 4}
        Parser.array_from_acgt_hash(input_different_keys).should == Parser.array_from_acgt_hash(input_normal_keys)
      end
    end
=begin
    context '::try_convert_to_array' do
      it 'should return array of arrays that are' do
        inputs = []
        inputs << {:A => [1,2,3], :c => [2,3,4], 'g' => [3,4,5], 'T' => [4,5,6]}
        inputs << [[1,2,3,4], [2,3,4,5], [3,4,5,6]]
        inputs << [{A:1, C:2, G:3, T:4},{A:2, C:3, G:4, T:5},{A:3, C:4, G:5, T:6}]
        inputs.each do |input|
          result = Parser.try_convert_to_array(input)
          result.should be_kind_of(Array)
          result.each{|el| el.should be_kind_of(Array) }
          #Parser.try_convert_to_array(input).should == [[1,2,3,4], [2,3,4,5], [3,4,5,6]]
          #result.each{|el| el.size.should == 4}
        end
      end
    end
=end  
  
    good_cases = {
      'Array Nx4' => {input: [[0,1,2,3],[10,11,12,13]], 
                        matrix: [[0,1,2,3],[10,11,12,13]] },
                        
      'Array 4xN' => {input: [[0,10],[1,11],[2,12],[3,13]],
                        matrix: [[0,1,2,3],[10,11,12,13]] },
                        
      'Hash A,C,G,T => Arrays' => { input: {:A => [0,10], :c => [1,11],'g' => [2,12],'T' => [3,13]}, 
                                    matrix: [[0,1,2,3],[10,11,12,13]] },
                                    
      'Hash array of hashes' => { input: [{:A => 0,:c => 1,'g' => 2,'T' => 3}, {:A => 10,:c => 11,'g' => 12,'T' => 13}],
                                  matrix: [[0,1,2,3],[10,11,12,13]] },
                                  
      'Array 4x4 (rows treated as positions, columns are treated as letter)' => { input: [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]],
                                                                                  matrix: [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]] },
                                                                                  
      'Hash A,C,G,T => 4-Arrays' => { input: {:A => [0,10,100,1000], :c => [1,11,101,1001],'g' => [2,12,102,1002],'T' => [3,13,103,1003]},
                                      matrix: [[0,1,2,3],[10,11,12,13],[100,101,102,103],[1000,1001,1002,1003]] },
                                      
      '4-Arrays of A,C,G,T hashes' => { input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                {:A => 10, :c => 11, 'g' => 12, 'T' => 13},
                                                {:A => 100, :c => 101, 'g' => 102, 'T' => 103},
                                                {:A => 1000, :c => 1001, 'g' => 1002, 'T' => 1003}],
                                        matrix: [[0,1,2,3],[10,11,12,13],[100,101,102,103],[1000,1001,1002,1003]] }
    }
    
    bad_cases = {
      'Different sizes of row arrays' => {input: [[1,2,3,4],[5,6,7,8,9]] },
      
      'Different sizes of column arrays' => {input: [[0,10],[1,11],[2,12],[3]] },
      
      'No one dimension have size 4' => {input: [[0,1,2,3,4],[10,11,12,13,14], [0,1,2,3,4]] },
      
      'Missing keys in column hashes' => {input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                     {:A => 10, :c => 11, 'g' => 12}] },
      'Bad keys in column hashes' => {input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                  {:A => 10, :c => 11, 'g' => 12, :X =>1000}] },
                                                  
      'Excessing keys in column hashes' => { input: [{:A => 0,:c => 1,'g' => 2,'T' => 3},
                                                     {:A => 10,:c => 11,'g' => 12,'T' => 13, :X => 1000}] },

      'Different sizes of row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12],'T' => [3,13,14]} },
      
      'Missing keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12]} },
      
      'Wrong keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'X' => [2,12]} },
      
      'Excessing keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12], 'T' => [3,12], :X => [4,14]} }
    }
    
    parser_specs(Parser, good_cases, bad_cases)
  end
end
