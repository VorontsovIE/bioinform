require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/pcm'

module Bioinform
  describe PPM do
    describe '#to_ppm' do
      let (:ppm_motif) { Fabricate(:ppm) }
      it 'returns self' do
         ppm_motif.to_ppm.should eq ppm_motif
      end
    end

    describe '#to_pcm' do
      let (:ppm_motif) { Fabricate(:ppm_by_pcm) }
      let (:pcm_motif) { Fabricate(:pcm) }

      it 'returns pcm using given effective_count' do
        ppm = ppm_motif.tap{|ppm| ppm.effective_count = pcm_motif.count }
        ppm.to_pcm.should == pcm_motif
      end
      it 'without given count it raises an error' do
        expect{ ppm_motif.to_pcm }.to raise_error
      end
      it 'returns pcm with the same name' do
        ppm = ppm_motif.tap{|ppm| ppm.effective_count = pcm_motif.count }
        ppm.to_pcm.name.should == ppm_motif.name
      end
    end

    describe '#to_pwm' do
      let (:ppm_motif_without_count) { Fabricate(:ppm_by_pcm) }
      let (:ppm_motif) { ppm_motif_without_count.tap{|ppm| ppm.effective_count = 137 } }
      let (:ppm_motif_with_log_pseudocount) { ppm_motif.tap{|ppm| ppm.effective_count = 137 } }
      let (:pcm_motif) { ppm_motif.to_pcm }

      it 'returns pwm the same as pwm of according pcm' do
        ppm_motif.to_pwm.should == pcm_motif.to_pwm
      end
      it 'uses pseudocount to transform according pcm to pwm' do
        ppm = ppm_motif.tap{|ppm| ppm.pseudocount = 10}
        ppm_motif.to_pwm.should == pcm_motif.to_pwm(10)
      end
      it 'by default uses pseudocount equal to log of count' do
        ppm_motif.to_pwm.should == ppm_motif.to_pcm.to_pwm(Math.log(137))
      end
      it 'without given count it raises an error' do
        expect{ ppm_motif_without_count.to_pwm }.to raise_error
      end
      it 'returns pwm with the same name' do
        ppm_motif.to_pwm.name.should == ppm_motif.name
      end
    end
  end
end
