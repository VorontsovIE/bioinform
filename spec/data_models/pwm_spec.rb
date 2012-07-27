require 'spec_helper'
require 'bioinform/data_models/pwm'

module Bioinform
  describe PWM do
    describe '#score_mean' do
      it 'should be equal to a mean score of pwm' do
        pwm = PWM.new( [[1,2,1,2],[4,6,8,6],[2,2,2,2]] )
        pwm.score_mean.should == 1.5 + 6 + 2
      end
      it 'should be equal to a mean score of pwm by measure induced from background probability mean' do
        pwm = PWM.new( [[1,2,1,2],[4,6,8,6],[2,2,2,2]] ).background([0.2, 0.3, 0.3, 0.2])
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

  end
end