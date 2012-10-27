require_relative '../../../spec_helper'

shared_examples 'single motif specified' do
  context 'single motif specified' do
    Given {
      make_model_file(sp1_f1, model_from)
    }
    Given(:motif_list) { [sp1_f1] }

    context 'when input is a pcm' do
      Given(:model_from) { 'pcm' }

      context 'pwm conversion invoked' do
        Given(:model_to) { 'pwm' }
        Then { resulting_stdout.should == sp1_f1.pwm }
      end

      context 'ppm conversion invoked' do
        Given(:model_to) { 'ppm' }
        Then { resulting_stdout.should == sp1_f1.ppm }
      end
    end
    
    context 'when input is a pwm' do
      Given(:model_from) { 'pwm' }

      context 'pcm conversion invoked' do
        Given(:model_to) { 'pcm' }
        include_examples 'yields motif conversion error'
      end

      context 'ppm conversion invoked' do
        Given(:model_to) { 'ppm' }
        include_examples 'yields motif conversion error'
      end
    end

    context 'if there exist other files in current folder' do
      Given {
        make_model_file(sp1_f1, model_from)
        make_model_file(klf4_f2, model_from)
      }
      Given(:model_from) { 'pcm' }
      Given(:model_to) { 'pwm' }
      Then { resulting_stdout.should == sp1_f1.pwm }
      Then { resulting_stdout.should_not match(klf4_f2.pwm) }
    end
    
  end
end