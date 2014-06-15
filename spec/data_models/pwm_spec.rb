require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/pwm'

module Bioinform
  describe PWM do
    describe '#score_mean' do
      it 'should be equal to a mean score of pwm' do
        pwm = PWM.new( [[1,2,1,2],[4,6,8,6],[2,2,2,2]] )
        pwm.score_mean.should == 1.5 + 6 + 2
      end
      it 'should be equal to a mean score of pwm by measure induced from background probability mean' do
        pwm = PWM.new( [[1,2,1,2],[4,6,8,6],[2,2,2,2]] ).tap{|x| x.background = [0.2, 0.3, 0.3, 0.2] }
        pwm.score_mean.should == ((0.2*1+0.3*2+0.3*1+0.2*2) + (0.2*4+0.3*6+0.3*8+0.2*6) + (0.2*2+0.3*2+0.3*2+0.2*2)) / (0.2+0.3+0.3+0.2)
      end
    end

    describe '#score_variance' do
    end

    describe '#gauss_estimation' do
    end

    describe '#score' do
      let(:pwm) do
        PWM.new( [[10000,20000,30000,40000],[1000,2000,3000,4000],[100,200,300,400],[10,20,30,40],[1,2,3,4]] )
      end
      it 'should evaluate to score of given word' do
        pwm.score('aAAAA').should == 11111
        pwm.score('agata').should == 13141
        pwm.score('CCGCT').should == 22324
      end
      it 'should give score average score(considering probabilities) for a position for a N-letter' do
        pwm.score('AANAA').should == (11011 + 250)
        pwm.tap{|x| x.background = [0.1,0.4,0.1,0.4]}.score('AANAA').should == (11011 + 0.1*100 + 0.4*200 + 0.1*300 + 0.4*400)
      end
      it 'should raise an ArgumentError if word contain bad letter' do
        expect{ pwm.score('AAAAV') }.to raise_error(ArgumentError)
      end
      it 'should raise an ArgumentError if word has size different than size of matrix' do
        expect{ pwm.score('AAA') }.to raise_error(ArgumentError)
      end
    end

    describe '#best_score' do
      it 'should be equal to best score' do
        @pwm = PWM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pwm.best_score.should == 4.9 + 7.13 + (-1.0)
      end
    end
    describe '#worst_score' do
      it 'should be equal to worst score' do
        @pwm = PWM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pwm.worst_score.should == 1.3 + 3.25 + (-1.5)
      end
    end

    describe '#best_suffix' do
      it 'should return maximal score of suffices from i-th position inclusively i.e. [i..end]' do
        @pwm = PWM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pwm.best_suffix(0).should == (4.9 + 7.13 - 1.0)
        @pwm.best_suffix(1).should == (7.13 - 1.0)
        @pwm.best_suffix(2).should == (-1.0)
        @pwm.best_suffix(3).should == (0.0)
      end
      it 'should give right results after left(right)_augment, discrete, reverse_complement etc' do
        pwm = PWM.new([[1, 2, 3, 4], [10,10.5,11,11.5]])
        pwm.best_suffix(1).should == 11.5
        pwm.left_augment(1).best_suffix(1).should == 15.5
      end
    end
    describe '#worst_suffix' do
      it 'should return minimal score of suffices from i-th position inclusively i.e. [i..end]' do
        @pwm = PWM.new( [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -1.0, -1.5, -1.0]] )
        @pwm.worst_suffix(0).should == (1.3 + 3.25 - 1.5)
        @pwm.worst_suffix(1).should == (3.25 - 1.5)
        @pwm.worst_suffix(2).should == (- 1.5)
        @pwm.worst_suffix(3).should == (0.0)
      end
    end

    describe '#round' do
      let(:matrix) { [[1.3, 2.0, 4.9, 3.2], [7.13, 6.5, 3.25, 4.633], [-1.0, -0.5, -1.5, -1.0]] }
      let(:pm) { PWM.new( matrix ).tap{|pm| pm.name = 'motif name'} }
      it 'gives model with matrix elements rounded' do
        pm.round(1).matrix.should == [[1.3, 2.0, 4.9, 3.2], [7.1, 6.5, 3.3, 4.6], [-1.0, -0.5, -1.5, -1.0]]
      end
      it 'gives PWM model' do
        pm.round(1).should be_kind_of(PWM)
      end
      it 'gives model with the same name' do
        pm.round(1).name.should == 'motif name'
      end
    end
  end
end
