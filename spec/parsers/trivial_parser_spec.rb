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
      it 'should return a hash based on input of that was passed to initialize when input is a Hash' do
        TrivialParser.new.parse!(matrix: 'stub matrix', name: 'stub name').should == {matrix: 'stub matrix', name: 'stub name'}
      end
    end
  end
end
