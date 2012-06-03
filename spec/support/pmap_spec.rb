require 'spec_helper'
require 'bioinform/support/pmap'

describe Enumerable do
  describe '#pmap!' do
    it 'should replace object itself' do
      x = [1,2,3]
      x.pmap!(&:to_s).should be_equal x
    end
    it 'should transform an object according to a block and a parameter' do
      [[1,2,3],[4,5,6]].pmap!(' ',&:join).join("\n").should == "1 2 3\n4 5 6"
      [1,2,3,4,5].pmap!(2,&:to_s).should == ['1', '10', '11', '100', '101']
    end
    
    context 'with parameters' do
      it 'should behave like if method call in map block accept an argument' do
        [1,2,3].pmap!(2, &:to_s).should == [1,2,3].map{|el| el.to_s(2)}
        [1,2,3].pmap!(2, &:to_s).should == ['1','10','11']
      end
    end
    context 'without parameters' do
      it 'should behave like usual map' do
        [1,2,3].pmap!(&:to_s).should == [1,2,3].map{|el| el.to_s}
        [1,2,3].pmap!(&:to_s).should == ['1','2','3']
      end
    end
  end
  describe '#pmap' do
    it 'should not replace original object' do
      x = [1,2,3]
      x.pmap(&:to_s).should_not be_equal x
    end
    it 'should transform collection the same way, a pmap! method does' do
      [1,2,3].pmap(2, &:to_s).should == [1,2,3].pmap!(2, &:to_s)
      [1,2,3].pmap(&:to_s).should == [1,2,3].pmap!(&:to_s)
    end
  end
end