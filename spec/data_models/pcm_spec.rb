require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/pcm'

module Bioinform
  describe PCM do
    describe '#count' do
      it 'should be equal to sum of elements at position' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).count.should == 7
        PCM.new([[1, 2.3, 3.2, 1],[4.4, 0.1, 1, 2]]).count.should == 7.5
      end
    end

    describe '#to_pwm' do
      it 'should return PWM' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_pwm.should be_kind_of(PWM)
      end
      it 'should make transformation: el --> log( (el + p_i*pseudocount) / (p_i*(count + pseudocount)) )' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_pwm(1).matrix.map{|line|line.map{|el| el.round(3)}}.should  == [[-0.47, 0.118, 0.486, -0.47],[0.754, -2.079, -0.47, 0.118]]
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_pwm(10).matrix.map{|line|line.map{|el| el.round(3)}}.should == [[-0.194, 0.057, 0.258, -0.194],[0.425, -0.531, -0.194, 0.057]]
      end
      it 'should use default pseudocount equal to log(count)' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_pwm.should == PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_pwm(Math.log(7))
      end
      it 'should preserve name' do
        PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: nil).to_pwm.name.should be_nil
        PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: 'Stub name').to_pwm.name.should == 'Stub name'
      end
    end

    describe '#to_ppm' do
      it 'should return PPM' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_ppm.should be_kind_of(PPM)
      end
      it 'should make transformation el --> el / count' do
        PCM.new([[1, 2, 3, 1],[4, 0, 1, 2]]).to_ppm.should == PPM.new([[1.0/7, 2.0/7, 3.0/7, 1.0/7],[4.0/7, 0.0/7, 1.0/7, 2.0/7]])
      end
      it 'should preserve name' do
        PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: nil).to_ppm.name.should be_nil
        PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: 'Stub name').to_ppm.name.should == 'Stub name'
      end
    end


  end
end