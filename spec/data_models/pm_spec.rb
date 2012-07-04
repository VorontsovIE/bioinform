require 'spec_helper'
require 'bioinform/data_models/pm'

module Bioinform
  describe PM do 
    include Parser::Helpers
    
    describe '#valid?' do
      it 'should be true iff an argument is an array of arrays of 4 numerics in a column' do
        PM.new.instance_eval{@matrix = [[1,2,3,4],[1,4,5,6.5]]; self }.valid?.should be_true
        PM.new.instance_eval{@matrix = {A: [1,1], C: [2,4], G: [3,5], T: [4, 6.5]}; self }.valid?.should be_false
        PM.new.instance_eval{@matrix = [{A:1,C:2,G:3,T:4},{A:1,C:4,G:5,T: 6.5}]; self }.valid?.should be_false
        PM.new.instance_eval{@matrix = [[1,2,3,4],[1,4,6.5]]; self }.valid?.should be_false
        PM.new.instance_eval{@matrix = [[1,2,3],[1,4,6.5]]; self }.valid?.should be_false
        PM.new.instance_eval{@matrix = [[1,2,'3','4'],[1,'4','5',6.5]]; self }.valid?.should be_false
      end
    end
    
    describe '#initialize' do
      context 'when parser specified' do
        before :each do
          parser_stub :ParserBad, false, { matrix: [[0,0,0,0],[1,1,1,1]], name: 'Bad' }
          parser_stub :ParserGood, true, { matrix: [[1,1,1,1],[1,1,1,1]], name: 'Good' }
          parser_stub :ParserWithIncompleteOutput, true, { name: 'Without `matrix` key' }
          parser_stub :ParserGoodWithoutName, true, { matrix: [[1,1,1,1],[1,1,1,1]] }
          parser_stub :ParserWithInvalidMatrix, true, { matrix: [[1,1,1],[1,1,1]] }
        end
        after :each do  
          parser_subclasses_cleanup 
        end
        
        it 'should raise an ArgumentError if parser cannot parse input' do
          expect{ PM.new('my stub input', ParserBad) }.to raise_error ArgumentError
        end
        it 'should raise an ArgumentError if parser output doesn\'t have `matrix` key' do
          expect{ PM.new('my stub input', ParserWithIncompleteOutput) }.to raise_error ArgumentError
        end
        it 'should raise an ArgumentError if parser output has invalid matrix' do
          expect{ PM.new('my stub input', ParserWithInvalidMatrix) }.to raise_error ArgumentError
        end
        
        context 'when parse was successful' do
          it 'should load matrix from parser\'s resulting hash' do
            pm = PM.new('my stub input', ParserGoodWithoutName)
            pm.matrix.should == [[1,1,1,1],[1,1,1,1]]
            pm.name.should be_nil
          end
          it 'should set other available attributes from parse resulting hash' do
            pm = PM.new('my stub input', ParserGood)
            pm.matrix.should == [[1,1,1,1],[1,1,1,1]]
            pm.name.should == 'Good'
          end
        end
      end
      
      context 'when parser not specified' do
        after :each do
          parser_subclasses_cleanup 
        end
        it 'should raise an ArgumentError if no one parser can parse input' do
          parser_stub :ParserBad, false, { matrix: [[0,0,0,0],[1,1,1,1]], name: 'Bad' }
          expect{ PM.new('my stub input') }.to raise_error ArgumentError
        end
        it 'should use first parsed which can parse input' do
          parser_stub :ParserBad, false, { matrix: [[0,0,0,0],[1,1,1,1]], name: 'Bad' }
          parser_stub :ParserGoodFirst, true, { matrix: [[1,1,1,1],[1,1,1,1]], name: 'GoodFirst' }
          parser_stub :ParserGoodSecond, true, { matrix: [[1,1,1,1],[1,1,1,1]], name: 'GoodSecond' }
          
          pm = PM.new('my stub input')
          pm.name.should == 'GoodFirst'
        end
      end
    end
    
    describe '#matrix=' do
      it 'should replace matrix if argument is a valid matrix' do
        @pm = PM.new()
        @pm.matrix.should be_nil
        
        @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
        @pm.matrix.should == [[1,2,3,4],[1,4,5,6.5]]
        
        @pm.matrix = [[1,4,5,6.5], [2,2,2,2]]
        @pm.matrix.should == [[1,4,5,6.5],[2,2,2,2]]
      end
      it 'should raise an exception if argument isn\'t valid matrix' do
        @pm = PM.new
        expect{  @pm.matrix = [[1,2,3,4],[1,4,5]]  }.to raise_error
      end
    end
    
    describe '#to_s' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
      end
      it 'should return string with single-tabulated multiline matrix' do
        @pm.to_s.should == "1\t2\t3\t4\n1\t4\t5\t6.5"
      end
      it 'should return positions in rows, letters in cols' do
        @pm.to_s.split("\n").size.should == 2
        @pm.to_s.split("\n").map{|pos| pos.split.size}.all?{|sz| sz==4}.should be_true
      end
      context 'with name specified' do
        before :each do
          @pm.name = 'Stub name'
        end
        it 'should return a string with a name and a matrix from the next line' do
          @pm.to_s.should == "Stub name\n1\t2\t3\t4\n1\t4\t5\t6.5"
        end
        it 'should not return a name if argument is set to false' do
          @pm.to_s(false).should == "1\t2\t3\t4\n1\t4\t5\t6.5"
        end
      end
    end
    
    describe '#pretty_string' do
      it 'should return a string formatted with spaces'
      it 'should contain first string of ACGT letters'
      context 'with name specified' do
        it 'should contain name if parameter isn\'t false'
      end
      context 'without name specified' do
        it 'should not contain name'
      end
    end
    
    describe '#size' do
      it 'should return number of positions' do
        @pm = PM.new
        @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
        @pm.size.should == 2
      end
    end
    
    describe '#to_hash' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
        @hsh = @pm.to_hash
      end
      it 'should return a hash with keys A, C, G, T' do
        @hsh.should be_kind_of Hash
        @hsh.keys.sort.should == %w{A C G T}
      end
      it 'should contain matrix elements of corresponding letter' do
        @hsh['A'].should == [1, 1]
        @hsh['C'].should == [2, 4]
        @hsh['G'].should == [3, 5]
        @hsh['T'].should == [4, 6.5]
      end
      it 'should be accessible both by name and symbol (e.g. pm.to_hash[:A] or pm.to_hash[\'A\'] is the same)' do
        @hsh['A'].should == @hsh[:A]
        @hsh['C'].should == @hsh[:C]
        @hsh['G'].should == @hsh[:G]
        @hsh['T'].should == @hsh[:T]
      end
    end
    
    describe '#background' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
      end
      context 'when none arguments passed' do
        context 'when pm just created' do
          it 'should be [1,1,1,1]' do
            @pm.background.should == [1,1,1,1]
          end
        end
        it 'should return background' do
          @pm.instance_eval { @background = [0.2, 0.3, 0.3, 0.2] }
          @pm.background.should == [0.2, 0.3, 0.3, 0.2]
        end
      end
      context 'when one argument passed' do
        it 'should set background' do
          @pm.background([0.2,0.3,0.3,0.2])
          @pm.background.should == [0.2, 0.3, 0.3, 0.2]
        end
      end
      context 'when more than one argument passed' do
        it 'should raise an ArgumentError' do
          expect { @pm.background(:first, :second, :third) }.to raise_error ArgumentError
        end
      end
    end
    
    describe '#reverse_complement!' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1, 2, 3, 4], [1, 4, 5, 6.5]]
      end
      it 'should return pm object itself' do
        @pm.reverse_complement!.should be_equal(@pm)
      end
      it 'should reverse matrix rows and columns' do
        @pm.reverse_complement!
        @pm.matrix.should == [[6.5, 5, 4, 1], [4, 3, 2, 1]]
      end
    end
    
    describe '#left_augment!' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1, 2, 3, 4], [1, 4, 5, 6.5]]
      end
      it 'should return pm object itself' do
        @pm.left_augment!(2).should be_equal(@pm)
      end
      it 'should add number of zero columns from the left' do
        @pm.left_augment!(2)
        @pm.matrix.should == [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [1, 2, 3, 4], [1, 4, 5, 6.5]]
      end
    end
    
    describe '#right_augment!' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1, 2, 3, 4], [1, 4, 5, 6.5]]
      end
      it 'should return pm object itself' do
        @pm.right_augment!(2).should be_equal(@pm)
      end
      it 'should add number of zero columns from the right' do
        @pm.right_augment!(2)
        @pm.matrix.should == [[1, 2, 3, 4], [1, 4, 5, 6.5], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]]
      end
    end
    
    describe '#shift_to_zero!' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1, 2, 3, 4], [5, 6.5, 3, 4]]
      end
      it 'should return pm object itself' do
        @pm.shift_to_zero!.should be_equal(@pm)
      end
      it 'should make shift each column' do
        @pm.shift_to_zero!
        @pm.matrix.should == [[0, 1, 2, 3], [2, 3.5, 0, 1]]
      end
    end
    
    describe '#discrete!' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 3.2, 4.9], [6.51, 6.5, 3.25, 4.633]]
      end
      it 'should return pm object itself' do
        @pm.discrete!(10).should be_equal(@pm)
      end
      context 'rate is 1' do
        it 'should discrete each element of matrix' do
          @pm.discrete!(1)
          @pm.matrix.should == [[2, 2, 4, 5], [7, 7, 4, 5]]
        end
      end
      it 'should discrete each element of matrix multiplied by rate' do
        @pm.discrete!(10)
        @pm.matrix.should == [[13, 20, 32, 49], [66, 65, 33, 47]]
      end
    end
    
    describe '#background_sum' do
      before :each do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6]]
      end
      context 'when background is [1,1,1,1]' do
        it 'should be 4' do
          @pm.background_sum.should == 4
        end
      end
      it 'should be sum of background' do
        @pm.background( [0.2, 0.3, 0.3, 0.2] )
        @pm.background_sum.should == 1.0
      end
    end
    
    describe '#vocabulary_volume' do
      before :each do
        @pm_2_positions = PM.new
        @pm_2_positions.matrix = [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6]]
        @pm_3_positions = PM.new
        @pm_3_positions.matrix = [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6], [1, 2, 3, 4]]
      end
      context 'when background is [1,1,1,1]' do
        it 'should be equal to number of words' do
          @pm_2_positions.vocabulary_volume.should == 4**2
          @pm_3_positions.vocabulary_volume.should == 4**3
        end
      end
      context 'when background is normalized probabilities' do
        it 'should be 1.0' do
          @pm_2_positions.background( [0.2, 0.3, 0.3, 0.2] )
          @pm_2_positions.background_sum.should == 1.0
          
          @pm_3_positions.background( [0.2, 0.3, 0.3, 0.2] )
          @pm_3_positions.background_sum.should == 1.0
        end
      end
    end
    
    describe '#best_score' do
      it 'should be equal to best score' do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        @pm.best_score.should == 4.9 + 7.13 + (-1.0)
      end
    end
    describe '#worst_score' do
      it 'should be equal to worst score' do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        @pm.worst_score.should == 1.3 + 3.25 + (-1.5)
      end
    end
    
    describe '#best_suffix' do
      it 'should be an array of best suffices from start of string and to empty suffix inclusive' do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        @pm.best_suffix.should == [(4.9 + 7.13 - 1.0), (7.13 - 1.0), (-1.0), (0.0) ]
      end
    end
    describe '#worst_suffix' do
      it 'should be an array of worst suffices from start of string and to empty suffix inclusive' do
        @pm = PM.new
        @pm.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        @pm.worst_suffix.should == [(1.3 + 3.25 - 1.5), (3.25 - 1.5), (- 1.5), (0.0) ]
      end
    end

    [:shift_to_zero, :reverse_complement].each do |meth|
      describe "nonbang method #{meth}" do
        before :each do
          @pm = PM.new
          @pm.matrix =   [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
          @pm_2 = PM.new
          @pm_2.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        end
        it 'should return copy of object not object itself' do
          @pm.send(meth).should_not be_equal @pm
        end
        it 'should == to bang-method' do
          @pm.send(meth).to_s.should == @pm_2.send("#{meth}!").to_s
        end
      end
    end
    
    [:discrete , :left_augment, :right_augment].each do |meth|
      describe "nonbang method #{meth}" do
        before :each do
          @pm = PM.new
          @pm.matrix =   [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
          @pm_2 = PM.new
          @pm_2.matrix = [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]]
        end
        it 'should return copy of object not object itself' do
          @pm.send(meth, 2).should_not be_equal @pm
        end
        it 'should == to bang-method' do
          @pm.send(meth, 2).to_s.should == @pm_2.send("#{meth}!", 2).to_s
        end
      end
    end
  end
end