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
        pwm = PWM.new( [[1,2,1,2],[4,6,8,6],[2,2,2,2]] ).set_parameters(background: [0.2, 0.3, 0.3, 0.2])
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
        pwm.left_augment!(1)
        pwm.best_suffix(1).should == 15.5
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

  end
end