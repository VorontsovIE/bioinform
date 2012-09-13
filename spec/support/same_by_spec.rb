require_relative '../spec_helper'
require_relative '../../lib/bioinform/support/same_by'

describe Enumerable do
  describe '#same_by?' do
    it 'should be work with both hashes and arrays' do
      ['a','b','c'].same_by?{|k| k.length}
      {'a'=>13,'b'=>12,'c'=>14}.same_by?{|k,v| v < 20}
    end
    it 'should be true for empty collections' do
      [].same_by?(&:length).should be_true
      [].same_by?.should be_true
    end
    context 'without block' do
      it 'should compare if all elements of collection are the same' do
        %w{cat cat cat}.same_by?.should be_true
        %w{cat dog rat}.same_by?.should be_false
      end
    end
    context 'with a block' do
      it 'should compare enumerables by a value of block' do
        %w{cat dog rat}.same_by?(&:length).should be_true
        %w{cat dog rabbit}.same_by?(&:length).should be_false
      end
      it 'should be true if all elements are true' do
        [4,8,2,2].same_by?(&:even?).should be_true
      end
      it 'should be true if all elements are false' do
        [1,3,9,7].same_by?(&:even?).should be_true
      end
      it 'should be false if some elements are true and some are false' do
        [1,8,3,2].same_by?(&:even?).should be_false
      end
    end
  end
end