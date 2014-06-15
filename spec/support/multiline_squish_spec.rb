require_relative '../spec_helper'
require_relative '../../lib/bioinform/support/multiline_squish'

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
    it 'should preserve empty lines in the middle of text' do
      "abc def\n\nghi\n \t  \njk lmn \n\n\n zzz".multiline_squish.should == "abc def\n\nghi\n\njk lmn\n\n\nzzz"
    end
    it 'should drop empty lines at begin and at end of string' do
      "\n  \t\n\nabc def\n\nghi\n \t  \njk lmn \n\n\n zzz\n\n \t  \n".multiline_squish.should == "abc def\n\nghi\n\njk lmn\n\n\nzzz"
    end
  end
end
