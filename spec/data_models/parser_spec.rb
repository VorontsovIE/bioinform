require 'spec_helper'
require 'bioinform/data_models/parser'


describe PM::Parser do
  before :all do
    class StubParserFirst < PM::Parser
      def parse
        { matrix: [[1,1,1,1],[1,1,1,1]], name: 'First matrix' }
      end
    end
    class StubParserSecond < PM::Parser
      def parse
        { matrix: [[2,2,2,2],[2,2,2,2],[2,2,2,2]] }
      end
    end
  end
  context 'when subklass created' do
    it 'PM::Parser.subclasses should contain all subclasses' do
      PM::Parser.subclasses.should include StubParserFirst
      PM::Parser.subclasses.should include StubParserSecond
    end
  end
  
  describe '#initialize' do
    it 'should save argument `input`'do
      parser = StubParserFirst.new('my stub input')
      parser.input.should == 'my stub input'
    end
  end
  describe '#parse' do
    it 'should raise an error unless reimplemented' do
      parser = PM::Parser.new('my stub input')
      expect{ parser.parse }.to raise_error NotImplementedError
    end
    context 'in a subclass' do
      it '!!! USELESS TEST - see TODO and make LINT for subclasses!!! should return hash with key `matrix`' do
        parser = StubParserFirst.new('my stub input')
        parse_result = parser.parse
        parse_result.should be_kind_of Hash
        parse_result.should have_key :matrix
      end
    end
  end
end
