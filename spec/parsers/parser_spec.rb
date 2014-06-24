require_relative '../spec_helper'
require 'bioinform/parsers/parser'

module Bioinform
  describe Parser do
    context '#initialize' do
      it 'should accept nucleotides_in correctly' do
        expect{ Parser.new(nucleotides_in: :rows) }.not_to raise_error
        expect{ Parser.new(nucleotides_in: :columns) }.not_to raise_error
      end
      it 'should fail if `nucleotides_in` has unknown value' do
        expect{ Parser.new(nucleotides_in: :somewhere) }.to raise_error Bioinform::Error
      end
    end

    context '::choose' do
      it 'should create parser of appropriate type' do
        expect( Parser.choose([[1,2,3,4],[5,6,7,8]]) ).to be_kind_of(Parser)
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
        allow(parser).to receive(:parse!).with('stub input') { 'stub result' }
        expect(parser.parse('stub input')).to eq 'stub result'
      end
      it 'should return nil if #parse! raised an exception' do
        parser = Parser.new
        allow(parser).to receive(:parse!).with('stub input').and_raise
        expect(parser.parse('stub input')).to be_nil
      end
    end

    good_cases = {
      'Array Nx4' => {input: [[1,2,3,4],[5,6,7,8]],
                      result: {name:nil, matrix: [[1,2,3,4],[5,6,7,8]]} },

      'Array 4x4 (rows treated as positions, columns are treated as letter)' => { input: [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]],
                                                                                  result: {name:nil, matrix: [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]} }
    }

    good_cases_transposed = {
      'Array 4xN' => {input: [[1,5],[2,6],[3,7],[4,8]],
                      result: {name:nil, matrix: [[1,2,3,4],[5,6,7,8]]} },
      'Array 4x4 (rows treated as letters, columns are treated as positions)' => { input: [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]],
                                                                                  result: {name:nil, matrix: [[1,5,9,13],[2,6,10,14],[3,7,11,15],[4,8,12,16]]} }
    }


    bad_cases = {
      'Nil object on input' => {input: nil},
      'Empty array on input' => {input: []},
      'Different sizes of row arrays' => {input: [[1,2,3,4],[5,6,7,8,9]] },
      'Different sizes of column arrays' => {input: [[0,10],[1,11],[2,12],[3]] },
      'No one dimension have size 4' => {input: [[0,1,2,3,4],[10,11,12,13,14], [0,1,2,3,4]] },
    }


    parser_specs(Parser.new, good_cases, bad_cases)
    parser_specs(Parser.new(nucleotides_in: :rows), good_cases_transposed, bad_cases)

    context '#parser!' do
      it "should raise an exception on parsing empty list to parser" do
        expect{ Parser.new.parse!() }.to raise_error
      end
    end
  end
end
