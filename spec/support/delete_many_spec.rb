require 'spec_helper'
require 'bioinform/support/delete_many'

describe Array do
  before :each do
    @arr = %w{a b c d e f g h i j b b}
  end
  describe '#delete_at_many' do
    it 'should delete elements at specified indices when indices in ascending order' do
      @arr.delete_at_many(1,3,7)
      @arr.should == %w{a c e f g i j b b}
    end
    it 'should delete elements at specified indices when indices in descending order' do
      @arr.delete_at_many(7,3,1)
      @arr.should == %w{a c e f g i j b b}
    end
    it 'should delete elements at specified indices when indices in arbitrary order' do
      @arr.delete_at_many(3,1,7)
      @arr.should == %w{a c e f g i j b b}
    end
    it 'should delete at each index once' do
      @arr.delete_at_many(0,0,0,2,0)
      @arr.should == %w{b d e f g h i j b b}
    end
  end
  describe '#delete_many' do
    it 'should delete multiple elements with specified values' do
      @arr.delete_many('b', 'd', 'h', 'b')
      @arr.should == %w{a c e f g i j}
    end
  end
end

describe Hash do
  before :each do
    @arr = {A: 3, T: 6, G: 4, C: 5}
  end
  describe '#delete_many' do
    it 'should delete specified keys' do
      @arr.delete_many(:T, :C, :F, :T, :T)
      @arr.should == {A: 3, G: 4}
    end
  end
end