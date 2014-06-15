require_relative '../spec_helper'
require_relative '../../lib/bioinform/support/array_zip'

describe Array do
  context '::zip' do
    it 'should take any number of arrays and zip them as if #zip was made to first and others' do
      Array.zip([1,2,3]).should == [1,2,3].zip()
      Array.zip([1,2,3],[4,5,6]).should == [1,2,3].zip([4,5,6])
      Array.zip([1,2,3],[4,5,6],[7,8,9]).should == [1,2,3].zip([4,5,6],[7,8,9])
    end
    it 'should return empty array if no arrays\'re given' do
      Array.zip().should == []
    end
  end
end
