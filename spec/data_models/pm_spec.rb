require 'spec_helper'
require 'bioinform/data_models/pm'

module Bioinform
  describe PM do 
    describe '#valid?' do
      it 'should be true iff an argument is an array of arrays of 4 numerics in a column' do

        PM.new([[0,0,0,0]]).instance_eval{@matrix = [[1,2,3,4],[1,4,5,6.5]]; self }.valid?.should be_true
        PM.new([[0,0,0,0]]).instance_eval{@matrix = {A: [1,1], C: [2,4], G: [3,5], T: [4, 6.5]}; self }.valid?.should be_false
        PM.new([[0,0,0,0]]).instance_eval{@matrix = [{A:1,C:2,G:3,T:4},{A:1,C:4,G:5,T: 6.5}]; self }.valid?.should be_false
        PM.new([[0,0,0,0]]).instance_eval{@matrix = [[1,2,3,4],[1,4,6.5]]; self }.valid?.should be_false
        PM.new([[0,0,0,0]]).instance_eval{@matrix = [[1,2,3],[1,4,6.5]]; self }.valid?.should be_false
        PM.new([[0,0,0,0]]).instance_eval{@matrix = [[1,2,'3','4'],[1,'4','5',6.5]]; self }.valid?.should be_false

      end
    end        
    
    describe '#to_s' do
      before :each do
        @pm = PM.new( [[1,2,3,4],[1,4,5,6.5]] )
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
      it 'should format string with 7-chars fields' do
        PM.new( [[1,2,3,4],[5,6,7,8]] ).pretty_string.should == "   A      C      G      T   \n   1.0    2.0    3.0    4.0\n   5.0    6.0    7.0    8.0"
      end
      it 'should return a string of floats formatted with spaces' do
        PM.new( [[1,2,3,4],[5,6,7,8]] ).pretty_string.should match(/1.0 +2.0 +3.0 +4.0 *\n *5.0 +6.0 +7.0 +8.0/)
      end
      it 'should contain first string of ACGT letters' do
        PM.new( [[1,2,3,4],[5,6,7,8]] ).pretty_string.lines.first.should match(/A +C +G +T/)
      end
      it 'should round floats upto 3 digits' do
        PM.new( [[1.1,2.22,3.333,4.4444],[5.5,6.66,7.777,8.8888]] ).pretty_string.should match(/1.1 +2.22 +3.333 +4.444 *\n *5.5 +6.66 +7.777 +8.889/)
      end
      
      context 'with name specified' do
        before :each do
          @pm = PM.new( [[1.1,2.22,3.333,4.4444],[5.5,6.66,7.777,8.8888]] )
          @pm.name = 'MyName'
        end
        it 'should contain name if parameter `with_name` isn\'t false' do
          @pm.pretty_string.should match(/MyName\n/)
        end
        it 'should not contain name if parameter `with_name` is false' do
          @pm.pretty_string(false).should_not match(/MyName\n/)
        end
      end
      context 'without name specified' do
        before :each do
          @pm = PM.new( [[1.1,2.22,3.333,4.4444],[5.5,6.66,7.777,8.8888]] )
        end
        it 'should not contain name whether parameter `with_name` is or isn\'t false' do
          @pm.pretty_string.should_not match(/MyName\n/)
          @pm.pretty_string(false).should_not match(/MyName\n/)
        end
      end
    end
    
    describe '#size' do
      it 'should return number of positions' do
        @pm = PM.new( [[1,2,3,4],[1,4,5,6.5]] )
        @pm.size.should == 2
      end
    end
    
    describe '#to_hash' do
      before :each do
        @pm = PM.new( [[1,2,3,4],[1,4,5,6.5]] )
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
        @pm = PM.new( [[1,2,3,4],[1,4,5,6.5]] )
      end
      context 'when none arguments passed' do
        context 'when pm just created' do
          it 'should be [1,1,1,1]' do
            @pm.background.should == [1,1,1,1]
          end
        end
        it 'should return background' do
          @pm.background = [0.2, 0.3, 0.3, 0.2]
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
          expect { @pm.background(:first, :second) }.to raise_error ArgumentError
        end
      end
    end
    
    describe '#reverse_complement!' do
      before :each do
        @pm = PM.new( [[1, 2, 3, 4], [1, 4, 5, 6.5]] )
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
        @pm = PM.new( [[1, 2, 3, 4], [1, 4, 5, 6.5]] )
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
        @pm = PM.new( [[1, 2, 3, 4], [1, 4, 5, 6.5]] )
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
        @pm = PM.new( [[1, 2, 3, 4], [5, 6.5, 3, 4]] )
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
        @pm = PM.new( [[1.3, 2.0, 3.2, 4.9], [6.51, 6.5, 3.25, 4.633]] )
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
        @pm = PM.new( [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6]] )
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
        @pm_2_positions = PM.new( [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6]] )
        @pm_3_positions = PM.new( [[1.3, 2.0, 3.2, 4.9], [5.0, 6.5, 3.2, 4.6], [1, 2, 3, 4]] )
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
        @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pm.best_score.should == 4.9 + 7.13 + (-1.0)
      end
    end
    describe '#worst_score' do
      it 'should be equal to worst score' do
        @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pm.worst_score.should == 1.3 + 3.25 + (-1.5)
      end
    end
    
    describe '#best_suffix' do
      it 'should return maximal score of suffices from i-th position inclusively i.e. [i..end]' do
        @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pm.best_suffix(0).should == (4.9 + 7.13 - 1.0)
        @pm.best_suffix(1).should == (7.13 - 1.0)
        @pm.best_suffix(2).should == (-1.0)
        @pm.best_suffix(3).should == (0.0)
      end
    end
    describe '#worst_suffix' do
      it 'should return minimal score of suffices from i-th position inclusively i.e. [i..end]' do
        @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pm.worst_suffix(0).should == (1.3 + 3.25 - 1.5)
        @pm.worst_suffix(1).should == (3.25 - 1.5)
        @pm.worst_suffix(2).should == (- 1.5)
        @pm.worst_suffix(3).should == (0.0)
      end
    end

    [:shift_to_zero, :reverse_complement].each do |meth|
      describe "nonbang method #{meth}" do
        before :each do
          @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
          @pm_2 = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
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
          @pm = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
          @pm_2 = PM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
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