require 'spec_helper'
require 'bioinform/data_models/parsers/hash_parser'

describe HashParser do
  before :each do
    @matrix = [[1,4,7,10], [2,5,8,11], [3,6,9,12]]
    
    @valid_input_symbolic_keys = {A: [1,2,3], C: [4,5,6], G: [7,8,9], T: [10,11,12]}
    @valid_input_string_keys = {'A' => [1,2,3], 'C' => [4,5,6], 'G' => [7,8,9], 'T' => [10,11,12]}
    @valid_array_of_hashes = [{A: 1, C: 4, G: 7, T: 10}, {A: 2, C: 5, G: 8, T: 11}, {A: 3, C: 6, G: 9, T: 12}]
    
    @invalid_array_of_hashes_missing_keys = [{A: 1, C: 4, G: 7, T: 10}, {C: 5, T: 11}, {A: 3, C: 6, G: 9, T: 12}]
    
    @invalid_input_different_length = {A: [1,2,3], C: [4,5,6], G: [7,8,9], T: [10]}
    @invalid_input_not_all_keys = {A: [1,2,3], C: [4,5,6], G: [7,8,9]}
    
    @invalid_not_hash_array = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    @invalid_not_hash_array_transposed = [[1,4,7,10], [2,5,8,11], [3,6,9,12]]
    
    @invalid_not_hash_string = "1 2 3\n4 5 6\n7 8 9\n10 11 12"
    @invalid_not_hash_string_transposed = "1 2 3 4\n5 6 7 8\n9 10 11 12"
  end
  describe '#can_parse?' do
    it 'should be true for a valid hash or array of hashes' do
      HashParser.new(@valid_input_symbolic_keys).can_parse?.should be_true
      HashParser.new(@valid_input_string_keys).can_parse?.should be_true
      HashParser.new(@valid_array_of_hashes).can_parse?.should be_true
    end
    it 'should be false for invalid input' do
      HashParser.new(@invalid_array_of_hashes_missing_keys).can_parse?.should be_false
      HashParser.new(@invalid_input_different_length).can_parse?.should be_false
      HashParser.new(@invalid_input_not_all_keys).can_parse?.should be_false
      
      HashParser.new(@invalid_not_hash_array).can_parse?.should be_false
      HashParser.new(@invalid_not_hash_array_transposed).can_parse?.should be_false
      
      HashParser.new(@invalid_not_hash_string).can_parse?.should be_false
      HashParser.new(@invalid_not_hash_string_transposed).can_parse?.should be_false
    end
  end
  describe '#parse' do
    it 'should raise an ArgumentError for invalid input' do
      expect{ HashParser.new(@invalid_input_different_length).parse }.to raise_error ArgumentError
      expect{ HashParser.new(@invalid_input_not_all_keys).parse }.to raise_error ArgumentError
      
      expect{ HashParser.new(@invalid_not_hash_array).parse }.to raise_error ArgumentError
      expect{ HashParser.new(@invalid_not_hash_array_transposed).parse }.to raise_error ArgumentError
      
      expect{ HashParser.new(@invalid_not_hash_string).parse }.to raise_error ArgumentError
      expect{ HashParser.new(@invalid_not_hash_string_transposed).parse }.to raise_error ArgumentError
    end
    it 'should return hash with `matrix` key for valid input' do
      HashParser.new(@valid_input_symbolic_keys).parse.should == {matrix: @matrix}
      HashParser.new(@valid_input_string_keys).parse.should == {matrix: @matrix}
      HashParser.new(@valid_array_of_hashes).parse.should == {matrix: @matrix}
    end
  end
end