require_relative '../spec_helper'
require 'bioinform/support/advanced_scan'

describe StringScanner do
  context '#advanced_scan' do
    before do
      @scanner = StringScanner.new('abcde  fghIJKLmnop')
    end
    it 'should return nil if text doesn\'t match. Pointer should not move' do
      @scanner.advanced_scan(/\s\s\s/).should be_nil
      @scanner.pos.should == 0
    end
    it 'should return MatchData if string Matches. Pointer should move' do
      @scanner.advanced_scan(/\w\w\w/).should be_kind_of MatchData
      @scanner.pos.should == 3
    end
    it 'should return have the same groups as regexp has' do
      result = @scanner.advanced_scan(/(\w+)(\s+)([a-z]+)([A-Z]+)/)
      result[0].should == 'abcde  fghIJKL'
      result[1].should == 'abcde'
      result[2].should == '  '
      result[3].should == 'fgh'
      result[4].should == 'IJKL'
    end
    it 'should return have the same named groups as regexp has' do
      result = @scanner.advanced_scan(/(\w+)(\s+)(?<word_downcase>[a-z]+)(?<word_upcase>[A-Z]+)/)
      result[0].should == 'abcde  fghIJKL'
      result[:word_downcase].should == 'fgh'
      result[:word_upcase].should == 'IJKL'
    end
  end
end
