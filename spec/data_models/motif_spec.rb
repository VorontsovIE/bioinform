require_relative '../../lib/bioinform/data_models/motif'

shared_examples 'when pm is PM' do
  context 'when pm-value is a PCM' do
    let(:pm) { Fabricate(:pcm) }
    it 'sets pcm-attribute to specified PM' do
      subject.pcm.should == Fabricate(:pcm)
    end
  end
  context 'when pm-value is a PWM' do
    let(:pm) { Fabricate(:pwm) }
    it 'sets pwm-attribute to specified PM' do
      subject.pwm.should == Fabricate(:pwm)
    end
  end
  context 'when pm-value is a PPM' do
    let(:pm) { Fabricate(:ppm) }
    it 'sets ppm-attribute to specified PM' do
      subject.ppm.should == Fabricate(:ppm)
    end
  end
  context 'when pm-value is a PM' do
    let(:pm) { Fabricate(:pm) }
    it 'sets only parameter pm attribute to specified PM' do
      subject.parameters.pm.should == Fabricate(:pm)
      subject.pcm.should be_nil
      subject.pwm.should be_nil
      subject.ppm.should be_nil
    end
  end
end


module Bioinform
  describe Motif do
    describe '.new' do
      it 'accepts empty argument list' do
        expect{ described_class.new }.to_not raise_error
      end

      context 'when argument is a Hash' do
        subject{ described_class.new(hash) }
        context 'which contains usual symbolic parameters' do
          let(:hash){ {:a => 123, :key => 'value', :threshold => {0.1 => 15} } }
          it 'sets its content as parameters' do
            subject.parameters.a.should == 123
            subject.parameters.key.should == 'value'
            subject.parameters.threshold.should == {0.1 => 15}
          end
        end
        context 'which contains any combination of :pwm, :pcm and :ppm keys' do
          let(:hash) { {pcm: 'my_pcm', ppm: 'my_ppm'} }
          it 'sets corresponding attributes to specified values' do
            subject.pcm.should == 'my_pcm'
            subject.ppm.should == 'my_ppm'
          end
        end
      end

      context 'when argument is a Hash with pm-key' do
        subject{ described_class.new(pm: pm) }

        include_examples 'when pm is PM'

        context 'when pm-value is a usual object' do
          let(:pm) { 'stub pm' }
          it 'sets only parameter pm attribute to specified value' do
            subject.parameters.pm.should == 'stub pm'
            subject.pcm.should be_nil
            subject.pwm.should be_nil
            subject.ppm.should be_nil
          end
        end
      end
      context 'when argument is neither PM nor Hash' do
        it 'raises ArgumentError' do
          expect{ described_class.new('stub pm') }.to raise_error, ArgumentError
        end
      end
    end

    ########################################################
    describe '#pcm' do
      subject {  motif.pcm }
      context 'when pcm is set' do
        context 'when pwm and ppm aren\'t setted' do
          let(:motif) { Fabricate(:motif_pcm) }
          it 'returns setted pcm' do
            subject.should == Fabricate(:pcm)
          end
        end
        context 'when ppm also setted' do
          let(:motif) { Fabricate(:motif_pcm_and_ppm) }
          it 'returns setted pcm' do
            subject.should == Fabricate(:pcm)
          end
        end
        context 'when pwm also setted' do
          let(:motif) { Fabricate(:motif_pcm_and_pwm) }
          it 'returns setted pcm' do
            subject.should == Fabricate(:pcm)
          end
        end
      end

      context 'when pcm isn\'t set' do
        context 'when nothing set' do
          let(:motif) { Fabricate(:motif) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
        context 'when pwm setted' do
          let(:motif) { Fabricate(:motif_pwm) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
        context 'when ppm setted' do
          let(:motif) { Fabricate(:motif_ppm) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
      end
    end
    ############################################
    describe '#pwm' do
      subject {  motif.pwm }
      context 'when pwm is set' do
        context 'when pcm and ppm aren\'t setted' do
          let(:motif) { Fabricate(:motif_pwm) }
          it 'returns setted pwm' do
            subject.should == Fabricate(:pwm)
          end
        end
        context 'when ppm also setted' do
          let(:motif) { Fabricate(:motif_pwm_and_ppm) }
          it 'returns setted pwm' do
            subject.should == Fabricate(:pwm)
          end
        end
        context 'when pcm also setted' do
          let(:motif) { Fabricate(:motif_pcm_and_pwm) }
          it 'returns setted pwm' do
            subject.should == Fabricate(:pwm)
          end
        end
      end

      context 'when pwm isn\'t set' do
        context 'when nothing set' do
          let(:motif) { Fabricate(:motif) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
        context 'when pcm setted' do
          let(:motif) { Fabricate(:motif_pcm) }
          it 'returns pcm converted to pwm' do
            subject.should == Fabricate(:pwm_by_pcm)
          end
        end
        context 'when ppm setted' do
          let(:motif) { Fabricate(:motif_ppm) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
      end
    end

    ############################################
    describe '#ppm' do
      subject {  motif.ppm }
      context 'when ppm is set' do
        context 'when pcm and pwm aren\'t setted' do
          let(:motif) { Fabricate(:motif_ppm) }
          it 'returns setted ppm' do
            subject.should == Fabricate(:ppm)
          end
        end
        context 'when pcm also setted' do
          let(:motif) { Fabricate(:motif_pcm_and_ppm) }
          it 'returns setted ppm' do
            subject.should == Fabricate(:ppm)
          end
        end
        context 'when pwm also setted' do
          let(:motif) { Fabricate(:motif_pwm_and_ppm) }
          it 'returns setted ppm' do
            subject.should == Fabricate(:ppm)
          end
        end
      end

      context 'when ppm isn\'t set' do
        context 'when nothing set' do
          let(:motif) { Fabricate(:motif) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
        context 'when pcm setted' do
          let(:motif) { Fabricate(:motif_pcm) }
          it 'returns pcm converted to ppm' do
            subject.should == Fabricate(:ppm_by_pcm)
          end
        end
        context 'when pwm setted' do
          let(:motif) { Fabricate(:motif_pwm) }
          it 'returns nil' do
            subject.should be_nil
          end
        end
      end
    end





  end
end