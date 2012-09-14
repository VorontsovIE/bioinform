require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/parser'
require_relative '../../lib/bioinform/data_models/collection'

module Bioinform
  describe TrivialParser do
    context '#initialize' do
      it 'should take the only input argument' do
        TrivialParser.instance_method(:initialize).arity.should == 1
      end
    end

    context '#parse!' do
      it 'should return OpenStruct based on input of that was passed to initialize when input is a Hash' do
        TrivialParser.new(matrix: 'stub matrix', name: 'stub name').parse!.should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end

      it 'should return OpenStruct based on input of that was passed to initialize when input is a OpenStruct' do
        TrivialParser.new(OpenStruct.new(matrix: 'stub matrix', name: 'stub name')).parse!.should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end
    end

    context '::split_on_motifs' do
      it 'should be able to get a single PM' do
        TrivialParser.split_on_motifs({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}, PM).should == [ PM.new(matrix: [[1,2,3,4],[5,6,7,8]], name:'Name') ]
      end
    end

    it 'can be used to create PM with {matrix: ..., name: ...} form' do
      pm = PM.new({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
      pm.matrix.should == [[1,2,3,4],[5,6,7,8]]
      pm.name.should == 'Name'
    end

    it 'can be used to create PM from PM (make copy)' do
      pm = Fabricate(:pm)
      pm_copy = PM.new(pm, TrivialParser)
      pm_copy.should == pm
    end
  end

  describe TrivialCollectionParser do
    before :each do
      @pm_1 = Fabricate(:pm_first)
      @pm_2 = Fabricate(:pm_second)
      @collection = Fabricate(:two_elements_collection)
    end

    describe '#parse!' do
      it 'can be used to obtain PMs from Collection' do
        @parser = TrivialCollectionParser.new(@collection)
        @parser.parse!.should == @pm_1
        @parser.parse!.should == @pm_2
        expect{ @parser.parse! }.to raise_error
      end
    end

    describe '::split_on_motifs' do
      it 'should be able to split collection into PMs' do
        TrivialCollectionParser.split_on_motifs(@collection).should == [@pm_1, @pm_2]
      end
    end
  end
end