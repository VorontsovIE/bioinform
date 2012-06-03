require 'spec_helper'
require 'bioinform/data_models/parser'


describe PM::Parser do
  include PM::Parser::Helpers
  
  before :each do
    parser_stub :ParserBad, false, { matrix: [[0,0,0,0],[1,1,1,1]], name: 'Bad' }
    parser_stub :ParserGood, true, { matrix: [[1,1,1,1],[1,1,1,1]], name: 'Good' }
  end
  after :each do  
    parser_subclasses_cleanup 
  end

  context 'when subklass created' do
    it 'PM::Parser.subclasses should contain all subclasses' do
      PM::Parser.subclasses.should include ParserBad
      PM::Parser.subclasses.should include ParserGood
    end
  end
  
  describe '#initialize' do
    it 'should save argument `input`'do
      parser = ParserGood.new('my stub input')
      parser.input.should == 'my stub input'
    end
  end
  
  describe '#parse' do
    it 'should raise an error unless reimplemented' do
      parser = PM::Parser.new('my stub input')
      expect{ parser.parse }.to raise_error
    end
    
    context 'in a subclass' do
      it '!!! USELESS TEST - see TODO and make LINT for subclasses!!! should return hash with key `matrix`' do
        parser = ParserGood.new('my stub input')
        parse_result = parser.parse
        parse_result.should be_kind_of Hash
        parse_result.should have_key :matrix
      end
    end
  end
end
