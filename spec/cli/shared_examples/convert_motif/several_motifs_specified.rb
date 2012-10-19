require_relative '../../../spec_helper'

shared_examples 'several motifs specified' do
  Given {
    make_model_file(sp1_f1, 'pcm')
    make_model_file(klf4_f2, 'pcm')
  }
  Given(:motif_list) { [sp1_f1, klf4_f2] }
  Given(:model_from) { 'pcm' }
  Given(:model_to) { 'pwm' }
  Then { resulting_stdout.should == [sp1_f1.pwm, klf4_f2.pwm].join("\n\n") }
end
