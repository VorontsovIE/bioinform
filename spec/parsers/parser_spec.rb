require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/parser'

module Bioinform
  describe Parser do
    context '#initialize' do
      it 'should accept an array correctly' do
        expect( Parser.new.parse([[1,2,3,4],[5,6,7,8]]).matrix ).to eq( [[1,2,3,4],[5,6,7,8]] )
      end
      it 'should treat several arguments as an array composed of them' do
        expect( Parser.new.parse([1,2,3,4],[5,6,7,8]) ).to eq Parser.new.parse([[1,2,3,4],[5,6,7,8]])
      end
      it 'should treat one Array of numbers as an Array(with 1 element) of Arrays' do
        expect( Parser.new.parse([1,2,3,4]) ).to eq Parser.new.parse([[1,2,3,4]])
      end
    end

    context '::parse!' do
      it 'should behave like Parser.new(input).parse!' do
        expect( Parser.parse!([1,2,3,4],[5,6,7,8]) ).to eq Parser.new.parse!([1,2,3,4],[5,6,7,8])
        expect{ Parser.parse!([1,2,3],[4,5,6]) }.to raise_error
      end
    end

    context '::parse' do
      it 'should behave like Parser.new(input).parse!' do
        expect( Parser.parse([1,2,3,4],[5,6,7,8]) ).to eq Parser.new.parse([1,2,3,4],[5,6,7,8])
        expect( Parser.parse([1,2,3],[4,5,6]) ).to be_nil
      end
    end

    context '::choose' do
      it 'should create parser of appropriate type' do
        expect( Parser.choose([[1,2,3,4],[5,6,7,8]]) ).to be_kind_of(Parser)
        # expect( Parser.choose([[1,2,3,4],[5,6,7,8]]).input ).to eq([[1,2,3,4],[5,6,7,8]])  ###################
        expect( Parser.choose(matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name') ).to be_kind_of(TrivialParser)
        # expect( Parser.choose(matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name').input ).to eq({matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'})  ###########
        # expect( Parser.choose("1 2 3 4\n5 6 7 8") ).to be_kind_of(StringParser)
        # expect( Parser.choose("1 2 3 4\n5 6 7 8").input ).to eq "1 2 3 4\n5 6 7 8" #############
      end
    end

    context 'CollectionParser#to_a' do
      it 'should be able to get a single PM' do
        expect( CollectionParser.new(Parser.new, [[1,2,3,4],[5,6,7,8]]).to_a ).to eq( [ OpenStruct.new(matrix: [[1,2,3,4],[5,6,7,8]], name: nil) ] )
      end
    end

    context '::need_transpose?' do
      it 'should point whether matrix have positions(need not be transposed -- false) or letters(true) as first index' do
        expect( Parser.need_tranpose?([[1,3,5,7], [2,4,6,8]]) ).to be_falsy
        expect( Parser.need_tranpose?([[1,2],[3,4],[5,6],[7,8]]) ).to be_truthy
      end
    end

    context '#parse' do
      it 'should give the same result as #parse!' do
        parser = Parser.new
        parser.stub(:parse!).and_return('stub result')
        expect(parser.parse).to eq 'stub result'
      end
      it 'should return nil if #parse! raised an exception' do
        parser = Parser.new
        parser.stub(:parse!).and_raise
        expect(parser.parse).to be_nil
      end
    end

    good_cases = {
      'Array Nx4' => {input: [[1,2,3,4],[5,6,7,8]],
                      result: OpenStruct.new(name:nil, matrix: [[1,2,3,4],[5,6,7,8]]) },

      'Array 4xN' => {input: [[1,5],[2,6],[3,7],[4,8]],
                      result: OpenStruct.new(name:nil, matrix: [[1,2,3,4],[5,6,7,8]]) },

      'Array 4x4 (rows treated as positions, columns are treated as letter)' => { input: [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]],
                                                                                  result: OpenStruct.new(name:nil, matrix: [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]) },
    }

    bad_cases = {
      'Nil object on input' => {input: nil},
      'Empty array on input' => {input: []},
      'Different sizes of row arrays' => {input: [[1,2,3,4],[5,6,7,8,9]] },
      'Different sizes of column arrays' => {input: [[0,10],[1,11],[2,12],[3]] },
      'No one dimension have size 4' => {input: [[0,1,2,3,4],[10,11,12,13,14], [0,1,2,3,4]] },
    }

    parser_specs(Parser, good_cases, bad_cases)
    context '#parser!' do
      it "should raise an exception on parsing empty list to parser" do
        expect{ Parser.new.parse!() }.to raise_error
      end
    end
  end
end
