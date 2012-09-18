require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/pcm'

module Bioinform
  describe PCM do
    describe '#count' do
      it 'should be equal to sum of elements at position' do
        Fabricate(:pcm).count.should == 7
        Fabricate(:pcm_with_floats).count.should == 7.5
      end
    end

    describe '#to_pwm' do
      subject{ Fabricate(:pcm) }
      it 'should return PWM' do
        Fabricate(:pcm).to_pwm.should be_kind_of(PWM)
      end
      it 'should make transformation: el --> log( (el + p_i*pseudocount) / (p_i*(count + pseudocount)) )' do
        subject.to_pwm(1).matrix.map{|line|line.map{|el| el.round(3)}}.should == Fabricate(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_1).matrix
        subject.to_pwm(10).matrix.map{|line|line.map{|el| el.round(3)}}.should == Fabricate(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_10).matrix
      end
      it 'should use default pseudocount equal to log(count)' do
        Fabricate(:pcm).to_pwm.should == Fabricate(:pcm).to_pwm(Math.log(7))
      end
      it 'should preserve name' do
        Fabricate(:pcm, name: nil).to_pwm.name.should be_nil
        Fabricate(:pcm, name: 'Stub name').to_pwm.name.should == 'Stub name'
      end
    end

    describe '#to_ppm' do
      let(:pcm_motif) { Fabricate(:pcm) }
      context 'returned object' do
        subject{ pcm_motif.to_ppm }
        it { should be_kind_of(PPM)}
        it 'should have matrix transformed with el --> el / count' do
          subject.matrix.should == Fabricate(:ppm_pcm_divided_by_count).matrix
        end
        context 'when source PCM name is absent' do
          let(:pcm_motif) { Fabricate(:pcm, name: nil) }
          it 'should have no name' do
            subject.name.should be_nil
          end
        end
        context 'when source PCM has name' do
          let(:pcm_motif) { Fabricate(:pcm, name: 'Stub-name') }
          it 'should has the same name' do
            subject.name.should == 'Stub-name'
          end
        end
      end
    end


  end
end