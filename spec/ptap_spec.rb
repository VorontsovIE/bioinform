require 'spec_helper'
require 'bioinform/support/ptap'

describe Enumerable do
  describe 'ptap' do
    it 'should act on original object itself' do
      x = ['abc','','','def','ghi']
      x.ptap('', &:delete).should be_equal x
    end
    context 'without parameters' do
      it 'should behave like usual tap' do
        'abc'.ptap(&:upcase!).should == 'abc'.tap(&:upcase!)
        'abc'.ptap(&:upcase!).should == 'ABC'
        'abc'.ptap(&:upcase).should == 'abc'.tap(&:upcase)
        'abc'.ptap(&:upcase).should == 'abc'
      end
    end
    context 'without parameters' do
      it 'should behave like if tap uses method call with given parameters' do
        ['abc','','','def','ghi'].ptap('',&:delete).should == ['abc','','','def','ghi'].tap{|slf| slf.delete ''}
        ['abc','','','def','ghi'].ptap('',&:delete).should == ['abc','def','ghi']
      end
    end
  end
end