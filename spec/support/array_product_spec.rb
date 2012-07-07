require 'spec_helper'
require 'bioinform/support/array_product'

describe Array do
  context '::product' do
    it 'should take any number of arrays and product them as if #product was made to first and others' do
      Array.product([1,2,3]).should == [1,2,3].product()
      Array.product([1,2,3],[4,5,6]).should == [1,2,3].product([4,5,6])
      Array.product([1,2,3],[4,5,6],[7,8,9]).should == [1,2,3].product([4,5,6],[7,8,9])
    end
    it 'should return empty array if no arrays\'re given' do
      Array.product().should == []
    end
  end
end