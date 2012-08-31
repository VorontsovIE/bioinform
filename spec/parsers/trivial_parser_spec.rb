require 'spec_helper'
require 'bioinform/parsers/parser'

module Bioinform
  describe TrivialParser do
    context '#initialize' do
      it 'should take the only input argument' do
        TrivialParser.instance_method(:initialize).arity.should == 1
      end
    end
    context '#parser!' do
      it 'should return input of that was passed to initialize' do
        TrivialParser.new('stub input').parse!.should == 'stub input'
      end
    end
    it 'can be used to create PM with {matrix: ..., name: ...} form' do
      pm = PM.new({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
      pm.matrix.should == [[1,2,3,4],[5,6,7,8]]
      pm.name.should == 'Name'
    end
  end
end
