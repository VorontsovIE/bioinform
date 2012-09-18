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
      let(:pcm_motif) { PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]]) }
      context 'returned object' do
        subject{pcm_motif.to_ppm}
        it { should be_kind_of(PPM)}
        it 'should have matrix transformed with el --> el / count' do
          subject.matrix.should == [[1, 2, 3, 1].map{|el| el.to_f / 7.0}, [4, 0, 1, 2].map{|el| el.to_f / 7.0}]
        end
        context 'when source PCM name is absent' do
          let(:pcm_motif) { PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: nil) }
          it 'should have no name' do
            subject.name.should be_nil
          end
        end
        context 'when source PCM has name' do
          let(:pcm_motif) { PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: 'Stub-name') }
          it 'should has the same name' do
            subject.name.should == 'Stub-name'
          end
        end
      end
    end


  end
end