require 'spec_helper'
require 'bioinform/support/multiline_squish'

describe String do
  describe '#multiline_squish' do
    it 'should replace multiple spaces with one space' do
      "abc def   ghi\n  jk  lmn".multiline_squish.should == "abc def ghi\njk lmn"
    end
    it 'should replace tabs with a space' do
      "abc\tdef   ghi \t jk".multiline_squish.should == 'abc def ghi jk'
    end
    it 'should replace \r\n with \n' do
      "abc def ghi\r\njk lmn".multiline_squish.should == "abc def ghi\njk lmn"
    end
    it 'should preserve rows pagination' do
      "abc def ghi\njk lmn".multiline_squish.should == "abc def ghi\njk lmn"
    end
  end
end