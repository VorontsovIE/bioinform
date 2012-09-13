require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/parser'

module Bioinform
  describe Parser do
    context '#initialize' do
      it 'should accept an array correctly' do
        Parser.new([[1,2,3,4],[5,6,7,8]]).parse.matrix.should == [[1,2,3,4],[5,6,7,8]]
      end
      it 'should treat several arguments as an array composed of them' do
        Parser.new([1,2,3,4],[5,6,7,8]).parse.should == Parser.new([[1,2,3,4],[5,6,7,8]]).parse
      end
      it 'should treat one Array of numbers as an Array(with 1 element) of Arrays' do
        Parser.new([1,2,3,4]).parse.should == Parser.new([[1,2,3,4]]).parse
      end
    end

    context '::parse!' do
      it 'should behave like Parser.new(input).parse!' do
        Parser.parse!([1,2,3,4],[5,6,7,8]).should  == Parser.new([1,2,3,4],[5,6,7,8]).parse!
        expect{ Parser.parse!([1,2,3],[4,5,6]) }.to raise_error
      end
    end

    context '::parse' do
      it 'should behave like Parser.new(input).parse!' do
        Parser.parse([1,2,3,4],[5,6,7,8]).should  == Parser.new([1,2,3,4],[5,6,7,8]).parse
        Parser.parse([1,2,3],[4,5,6]).should be_nil
      end
    end

    context '::choose' do
      it 'should create parser of appropriate type' do
        Parser.choose([[1,2,3,4],[5,6,7,8]]).should be_kind_of(Parser)
        Parser.choose([[1,2,3,4],[5,6,7,8]]).input.should == [[1,2,3,4],[5,6,7,8]]
        Parser.choose(matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name').should be_kind_of(TrivialParser)
        Parser.choose(matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name').input.should == {matrix: [[1,2,3,4],[5,6,7,8]], name: 'Name'}
        Parser.choose("1 2 3 4\n5 6 7 8").should be_kind_of(StringParser)
        Parser.choose("1 2 3 4\n5 6 7 8").input.should == "1 2 3 4\n5 6 7 8"
      end
    end

    context '::split_on_motifs' do
      it 'should be able to get a single PM' do
        Parser.split_on_motifs([[1,2,3,4],[5,6,7,8]], PM).should == [ PM.new(matrix: [[1,2,3,4],[5,6,7,8]], name:nil) ]
      end
    end

    context '::normalize_hash_keys' do
      it 'should convert both symbolic and string keys, in both upcase and downcase to symbolic upcases' do
        Parser.normalize_hash_keys( {a: 1, C: 2, 'g' => 3, 'T' => 4} ).should == {A: 1, C: 2, G: 3, T: 4}
      end
    end

    context '::need_transpose?' do
      it 'should point whether matrix have positions(need not be transposed -- false) or letters(true) as first index' do
        Parser.need_tranpose?([[1,3,5,7], [2,4,6,8]]).should be_false
        Parser.need_tranpose?([[1,2],[3,4],[5,6],[7,8]]).should be_true
      end
    end
    context '::array_from_acgt_hash' do
      it 'should convert hash of arrays to a transposed array of arrays' do
        input = {A: [1,2,3], C: [2,3,4], G: [3,4,5], T: [4,5,6]}
        Parser.array_from_acgt_hash(input).should == [[1,2,3], [2,3,4], [3,4,5], [4,5,6]].transpose
      end
      it 'should convert hash of numbers to an array of numbers' do
        input = {A: 1, C: 2, G: 3, T: 4}
        Parser.array_from_acgt_hash(input).should == [1,2,3,4]
      end
      it 'should process both symbolic and string keys, in both upcase and downcase' do
        input_normal_keys = {A: 1, C: 2, G: 3, T: 4}
        input_different_keys = {:A => 1, :c => 2, 'g' => 3, 'T' => 4}
        Parser.array_from_acgt_hash(input_different_keys).should == Parser.array_from_acgt_hash(input_normal_keys)
      end
    end

    context '::try_convert_to_array' do
      it 'should not change array' do
        inputs = []
        inputs << [[1,2,3,4], [2,3,4,5], [3,4,5,6]]
        inputs << [{A:1, C:2, G:3, T:4}, {A:2, C:3, G:4, T:5}, {A:3, C:4, G:5, T:6}]
        inputs.each do |input|
          Parser.try_convert_to_array( input ).should == input
        end
      end
      it 'should convert ACGT-Hashes to an array of positions (not letters)' do
        Parser.try_convert_to_array( {:A => [1,2,3], :c => [2,3,4], 'g' => [3,4,5], 'T' => [4,5,6]} ).should == [[1,2,3],[2,3,4],[3,4,5],[4,5,6]].transpose
      end
    end

    context '#parse' do
      it 'should give the same result as #parse!' do
        parser = Parser.new('stub parser')
        parser.stub(:parse!).and_return('stub result')
        parser.parse.should == 'stub result'
      end
      it 'should return nil if #parse! raised an exception' do
        parser = Parser.new('stub parser')
        parser.stub(:parse!).and_raise
        parser.parse.should be_nil
      end
    end

    good_cases = {
      'Array Nx4' => {input: [[0,1,2,3],[10,11,12,13]],
                        matrix: [[0,1,2,3],[10,11,12,13]] },

      'Array 4xN' => {input: [[0,10],[1,11],[2,12],[3,13]],
                        matrix: [[0,1,2,3],[10,11,12,13]] },

      'Hash A,C,G,T => Arrays' => { input: {:A => [0,10], :c => [1,11],'g' => [2,12],'T' => [3,13]},
                                    matrix: [[0,1,2,3],[10,11,12,13]] },

      'Hash array of hashes' => { input: [{:A => 0,:c => 1,'g' => 2,'T' => 3}, {:A => 10,:c => 11,'g' => 12,'T' => 13}],
                                  matrix: [[0,1,2,3],[10,11,12,13]] },

      'Array 4x4 (rows treated as positions, columns are treated as letter)' => { input: [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]],
                                                                                  matrix: [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]] },

      'Hash A,C,G,T => 4-Arrays' => { input: {:A => [0,10,100,1000], :c => [1,11,101,1001],'g' => [2,12,102,1002],'T' => [3,13,103,1003]},
                                      matrix: [[0,1,2,3],[10,11,12,13],[100,101,102,103],[1000,1001,1002,1003]] },

      '4-Arrays of A,C,G,T hashes' => { input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                {:A => 10, :c => 11, 'g' => 12, 'T' => 13},
                                                {:A => 100, :c => 101, 'g' => 102, 'T' => 103},
                                                {:A => 1000, :c => 1001, 'g' => 1002, 'T' => 1003}],
                                        matrix: [[0,1,2,3],[10,11,12,13],[100,101,102,103],[1000,1001,1002,1003]] }
    }

    bad_cases = {
      'Nil object on input' => {input: nil},

      'Empty array on input' => {input: []},

      'Different sizes of row arrays' => {input: [[1,2,3,4],[5,6,7,8,9]] },

      'Different sizes of column arrays' => {input: [[0,10],[1,11],[2,12],[3]] },

      'No one dimension have size 4' => {input: [[0,1,2,3,4],[10,11,12,13,14], [0,1,2,3,4]] },

      'Missing keys in column hashes' => {input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                     {:A => 10, :c => 11, 'g' => 12}] },
      'Bad keys in column hashes' => {input: [{:A => 0, :c => 1, 'g' => 2, 'T' => 3},
                                                  {:A => 10, :c => 11, 'g' => 12, :X =>1000}] },

      'Excessing keys in column hashes' => { input: [{:A => 0,:c => 1,'g' => 2,'T' => 3},
                                                     {:A => 10,:c => 11,'g' => 12,'T' => 13, :X => 1000}] },

      'Different sizes of row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12],'T' => [3,13,14]} },

      'Missing keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12]} },

      'Wrong keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'X' => [2,12]} },

      'Excessing keys in row hashes' => {input: {:A => [0,10], :c => [1,11],'g' => [2,12], 'T' => [3,12], :X => [4,14]} }
    }

    parser_specs(Parser, good_cases, bad_cases)
    context '#parser!' do
      it "should raise an exception on parsing empty list to parser" do
        expect{ Parser.new().parse! }.to raise_error
      end
    end
  end
end
