require 'spec_helper'
require 'bioinform/data_models/parsers/string_parser'

module Bioinform
  describe StringParser do
    before :each do
      @matrix = [[1.23, 4.56, 7.8, 9.0],[9.0, -8.7, 6.54, -3210.0]]
      
      @input_with_name = <<-EOS
        Testmatrix
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210
      EOS
      
      @input_with_name_with_introduction_sign = <<-EOS
        > Testmatrix
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210
      EOS
      
      @input_with_name_with_special_characters = <<-EOS
        Testmatrix_first:subname+sub-subname
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210
      EOS
      
      @input_with_tabs_and_multiple_spaces = <<-EOS
        > \tTestmatrix
        1.23  \t 4.56 7.8\t\t 9.0
        9    -8.7 6.54 -3210
      EOS
      
      @input_with_windows_crlf = <<-EOS
        > Testmatrix\r
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210\r
      EOS
      
      @input_with_leading_and_finishing_spaces_and_newlines = <<-EOS
        \n\n
        \t1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210
          \t\r\n\t\n
      EOS
      
      @input_without_name = <<-EOS
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3210
      EOS
      
      @input_with_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3.210e3
      EOS
      
      @input_with_plus_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3.210e+3
      EOS
      
      @input_with_minus_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9 -87e-1 6.54 -3210
      EOS
      
      @input_with_upcase_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -3.210E3
      EOS
      
      @input_with_manydigit_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9 -8.7 6.54 -0.0000003210e10
      EOS
      
      @input_transposed = <<-EOS
        1.23 9  
        4.56 -8.7
        7.8 6.54 
        9.0 -3210
      EOS
      
      
      @bad_input_not_numeric = <<-EOS
        1.23 4.56 aaa 9.0
        9 -8.7 6.54 -3210
      EOS
      
      @bad_input_different_row_size = <<-EOS
        1.23 4.56 7.8 9
        9 -8.7 6.54
      EOS
      
      @bad_input_not_4_rows_and_cols = <<-EOS
        1.23  4.56  7.8 
        9    -8.7   6.54
        10    2     10
        4     5     6
        1     1     1
      EOS
      
      @bad_input_with_empty_exponent = <<-EOS
        1.23 4.56 7.8 9.0
        9e -8.7 6.54 3210
      EOS
    end
    
    describe '#can_parse?' do
      it 'should return true for valid input string' do
        StringParser.new(@input_with_name).can_parse?.should be_true
        StringParser.new(@input_with_name_with_introduction_sign).can_parse?.should be_true
        StringParser.new(@input_with_name_with_special_characters).can_parse?.should be_true
        StringParser.new(@input_with_tabs_and_multiple_spaces).can_parse?.should be_true
        StringParser.new(@input_with_windows_crlf).can_parse?.should be_true
        StringParser.new(@input_with_leading_and_finishing_spaces_and_newlines).can_parse?.should be_true
        StringParser.new(@input_without_name).can_parse?.should be_true
        StringParser.new(@input_transposed).can_parse?.should be_true
        StringParser.new(@input_with_exponent).can_parse?.should be_true
        StringParser.new(@input_with_plus_exponent).can_parse?.should be_true
        StringParser.new(@input_with_minus_exponent).can_parse?.should be_true
        StringParser.new(@input_with_upcase_exponent).can_parse?.should be_true
        StringParser.new(@input_with_manydigit_exponent).can_parse?.should be_true
        
      end
      it 'should return false for invalid input string' do
        StringParser.new(@bad_input_not_numeric).can_parse?.should be_false
        StringParser.new(@bad_input_different_row_size).can_parse?.should be_false
        StringParser.new(@bad_input_not_4_rows_and_cols).can_parse?.should be_false
        StringParser.new(@bad_input_with_empty_exponent).can_parse?.should be_false
      end
    end
    describe '#parse' do
      it 'should return a hash with matrix and possibly name keys for valid input string' do
        StringParser.new(@input_with_name).parse.should == {matrix: @matrix, name: 'Testmatrix'}
        StringParser.new(@input_with_name_with_introduction_sign).parse.should == {matrix: @matrix, name: 'Testmatrix'}
        StringParser.new(@input_with_name_with_special_characters).parse.should == {matrix: @matrix, name: 'Testmatrix_first:subname+sub-subname'}
        StringParser.new(@input_with_tabs_and_multiple_spaces).parse.should == {matrix: @matrix, name: 'Testmatrix'}
        StringParser.new(@input_with_windows_crlf).parse.should == {matrix: @matrix, name: 'Testmatrix'}
        StringParser.new(@input_with_leading_and_finishing_spaces_and_newlines).parse.should == {matrix: @matrix}
        StringParser.new(@input_without_name).parse.should == {matrix: @matrix}
        StringParser.new(@input_transposed).parse.should == {matrix: @matrix}
        StringParser.new(@input_with_exponent).parse.should == {matrix: @matrix}
        StringParser.new(@input_with_plus_exponent).parse.should == {matrix: @matrix}
        StringParser.new(@input_with_minus_exponent).parse.should == {matrix: @matrix}
        StringParser.new(@input_with_upcase_exponent).parse.should == {matrix: @matrix}
        StringParser.new(@input_with_manydigit_exponent).parse.should == {matrix: @matrix}
      end
      it 'should raise an error for invalid input string' do
        expect{ StringParser.new(@bad_input_not_numeric).parse }.to raise_error ArgumentError
        expect{ StringParser.new(@bad_input_different_row_size).parse }.to raise_error ArgumentError
        expect{ StringParser.new(@bad_input_not_4_rows_and_cols).parse }.to raise_error ArgumentError
        expect{ StringParser.new(@bad_input_with_empty_exponent).parse }.to raise_error ArgumentError
      end
    end
  end
end