require_relative '../spec_helper'
require 'bioinform/parsers/parser'

module Bioinform
  describe TrivialParser do
    context '.new' do
      it 'should take the only input argument' do
        TrivialParser.instance_method(:initialize).arity.should == 0
      end
    end

    context '#parse!' do
      it 'should return OpenStruct based on input of that was passed to initialize when input is a Hash' do
        TrivialParser.new.parse!(matrix: 'stub matrix', name: 'stub name').should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end

      it 'should return OpenStruct based on input of that was passed to initialize when input is a OpenStruct' do
        TrivialParser.new.parse!(OpenStruct.new(matrix: 'stub matrix', name: 'stub name')).should == OpenStruct.new(matrix: 'stub matrix', name: 'stub name')
      end
    end

    context 'CollectionParser#to_a' do
      it 'should be able to get a single PM' do
        CollectionParser.new(TrivialParser.new, {matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}).to_a.should == [ OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8]], name:'Name') ]
      end
    end

    # it 'can be used to create PM with {matrix: ..., name: ...} form' do
    #   pm = PM.new({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
    #   pm.matrix.should == [[1,2,3,4],[5,6,7,8]]
    #   pm.name.should == 'Name'
    # end
  end
end
