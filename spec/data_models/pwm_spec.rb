require 'spec_helper'
require 'bioinform/data_models/pwm'

module Bioinform
  describe PWM do
    describe '#score_mean' do
      it 'should be equal to a mean score of pwm' do
        pwm = PWM.new
        pwm.matrix = [[1,2,1,2],[4,6,8,6],[2,2,2,2]]
        pwm.score_mean.should == 1.5 + 6 + 2
      end
      it 'should be equal to a mean score of pwm by measure induced from background probability mean' do
        pwm = PWM.new.background([0.2, 0.3, 0.3, 0.2])
        pwm.matrix = [[1,2,1,2],[4,6,8,6],[2,2,2,2]]
        pwm.score_mean.should == ((0.2*1+0.3*2+0.3*1+0.2*2) + (0.2*4+0.3*6+0.3*8+0.2*6) + (0.2*2+0.3*2+0.3*2+0.2*2)) / (0.2+0.3+0.3+0.2)
      end
    end
    
    describe '#score_variance' do
    end
    
    describe '#gauss_estimation' do
    end
  end
end