require 'spec_helper'
require 'bioinform/parsers/parser'
require 'bioinform/data_models/collection'

module Bioinform
  describe TrivialParser do
    context '#initialize' do
      it 'should take the only input argument' do
        TrivialParser.instance_method(:initialize).arity.should == 1
      end
    end
    context '#parser!' do
      it 'should return OpenStruct based on input of that was passed to initialize when input is a Hash' do
        TrivialParser.new(matrix: 'stub matrix', name: 'stub name').parse!.should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end
      it 'should return OpenStruct based on input of that was passed to initialize when input is a OpenStruct' do
        TrivialParser.new(OpenStruct.new(matrix: 'stub matrix', name: 'stub name')).parse!.should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end
    end
    it 'can be used to create PM with {matrix: ..., name: ...} form' do
      pm = PM.new({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
      pm.matrix.should == [[1,2,3,4],[5,6,7,8]]
      pm.name.should == 'Name'
    end
    it 'can be used to create PM from PM (make copy)' do
      pm = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix name')
      pm_copy = PM.new(pm, TrivialParser)
      pm_copy.should == pm
    end
  end
  describe TrivialCollectionParser do
    it 'can be used to obtain PMs from Collection' do
      pm_1 = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix-1 name')
      pm_2 = PM.new(matrix:[[15,16,17,18],[11,12,13,14]], name:'Matrix-2 name')
      collection = Collection.new
      collection << pm_1 << pm_2
      parser = TrivialCollectionParser.new(collection)
      parser.parse!.should == pm_1
      parser.parse!.should == pm_2
      expect{ parser.parse! }.to raise_error
    end
  end
end
