require 'spec_helper'
require 'bioinform/data_models/parsers'

module Bioinform
  describe ArrayParser do
    before :each do
      @matrix = [[1,4,7,10], [2,5,8,11], [3,6,9,12]]
      
      @valid_input = [[1,4,7,10], [2,5,8,11], [3,6,9,12]]
      @valid_input_transposed = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
      
      @invalid_array_of_hashes = [{A: 1, C: 4, G: 7, T: 10}, {A: 2, C: 5, G: 8, T: 11}, {A: 3, C: 6, G: 9, T: 12}]
      @invalid_input_hash = {A: [1,2,3], C: [4,5,6], G: [7,8,9], T: [10,11,12]}
      
      @invalid_input_array_different_size = [[1,4,7,10], [2,5,8,11], [3,6]]
      @invalid_input_array_transposed_different_size = [[1,2,3],[4,5,6],[7,8,9],[10]]
      
      @invalid_not_hash_string = "1 2 3\n4 5 6\n7 8 9\n10 11 12"
      @invalid_not_hash_string_transposed = "1 2 3 4\n5 6 7 8\n9 10 11 12"
    end
    
    describe '#can_parse?' do
      it 'should be true for a valid array' do
        ArrayParser.new(@valid_input).can_parse?.should be_true
        ArrayParser.new(@valid_input_transposed).can_parse?.should be_true
      end
      it 'should be false for invalid input' do
        ArrayParser.new(@invalid_array_of_hashes).can_parse?.should be_false
        ArrayParser.new(@invalid_input_hash).can_parse?.should be_false
        
        ArrayParser.new(@invalid_input_array_different_size).can_parse?.should be_false
        ArrayParser.new(@invalid_input_array_transposed_different_size).can_parse?.should be_false
        
        ArrayParser.new(@invalid_not_hash_string).can_parse?.should be_false
        ArrayParser.new(@invalid_not_hash_string_transposed).can_parse?.should be_false
      end
    end
    describe '#parse' do
      it 'should raise an ArgumentError for invalid input' do
        expect{ ArrayParser.new(@invalid_array_of_hashes).parse }.to raise_error ArgumentError
        expect{ ArrayParser.new(@invalid_input_hash).parse }.to raise_error ArgumentError
        expect{ ArrayParser.new(@invalid_input_array_different_size).parse }.to raise_error ArgumentError
        expect{ ArrayParser.new(@invalid_input_array_transposed_different_size).parse }.to raise_error ArgumentError
        expect{ ArrayParser.new(@invalid_not_hash_string).parse }.to raise_error ArgumentError
        expect{ ArrayParser.new(@invalid_not_hash_string_transposed).parse }.to raise_error ArgumentError
      end
      it 'should return hash with `matrix` key for valid input' do
        ArrayParser.new(@valid_input).parse.should == {matrix: @matrix}
        ArrayParser.new(@valid_input_transposed).parse.should == {matrix: @matrix}
      end
    end
  end
end