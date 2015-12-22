require 'bioinform/conversion_algorithms/pwm2pcm_converter'

describe Bioinform::ConversionAlgorithms::PWM2PCMConverter do
  specify { expect(Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(count: 137).count).to eq 137 }
  specify { expect(Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(pseudocount: 5).pseudocount).to eq 5 }
  specify {
    bckgr = Bioinform::Frequencies.new([0.1,0.4,0.4,0.1])
    expect(Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(background: bckgr).background).to eq bckgr
  }
  
  context 'from PWM converted by PCM2PWMConverter' do
    let(:specified_pseudocount) { 5 }
    let(:pcm) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]]) }

    
    specify do
      pwm = Bioinform::ConversionAlgorithms::PCM2PWMConverter.new(pseudocount: specified_pseudocount).convert(pcm)
      expect(Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(count: 10, pseudocount: specified_pseudocount).convert(pwm)).to be_within_range_from_matrix(pcm, 1e-10)
    end
    specify do
      pwm = Bioinform::ConversionAlgorithms::PCM2PWMConverter.new.convert(pcm)
      expect(Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(count: 10).convert(pwm)).to be_within_range_from_matrix(pcm, 1e-10)
    end
  end

  specify do
    pwm = Bioinform::MotifModel::PWM.new([[1,2,3,4],[2,2,2,4]])      
    pcm = Bioinform::ConversionAlgorithms::PWM2PCMConverter.new(count: 137).convert(pwm)
    expect(pcm.count).to be_within(1e-10).of(137)
  end

  context 'with default converter' do
    let(:converter) { Bioinform::ConversionAlgorithms::PWM2PCMConverter.new }

    let(:pwm) { Bioinform::MotifModel::PWM.new([[1,2,3,4],[2,2,2,4]]) }
    let(:pcm) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]]) }
    let(:ppm) { Bioinform::MotifModel::PPM.new([[0.1,0.2,0.3,0.4],[0.2,0.2,0.2,0.4]]) }

    let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
    let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }


    specify { expect(converter.count).to eq 100 }
    specify { expect(converter.pseudocount).to eq :default }
    specify { expect(converter.background).to eq Bioinform::Background::Uniform }

    specify { expect(converter.convert(pwm)).to be_kind_of Bioinform::MotifModel::PCM }

    specify { expect(converter.convert(named_pwm)).to be_kind_of Bioinform::MotifModel::NamedModel }
    specify { expect(converter.convert(named_pwm).model).to be_kind_of Bioinform::MotifModel::PCM }
    specify { expect(converter.convert(named_pwm).name).to eq 'motif name' }

    specify { expect{ converter.convert(pcm) }.to raise_error(Bioinform::Error) }
    specify { expect{ converter.convert(ppm) }.to raise_error(Bioinform::Error) }
    specify { expect{ converter.convert(named_pcm) }.to raise_error(Bioinform::Error) }
  end
end
