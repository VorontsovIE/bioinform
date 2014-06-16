require 'bioinform/conversion_algorithms/pcm2pwm_converter'

describe Bioinform::ConversionAlgorithms::PCM2PWMConverter_ do
  let(:pcm) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:pwm) { Bioinform::MotifModel::PWM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:ppm) { Bioinform::MotifModel::PPM.new([[0.1,0.2,0.3,0.4],[0.2,0.2,0.2,0.4]]) }
  let(:pcm_different_counts) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4],[3,3,3,4]]) }

  let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
  let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }

  context 'with default converter' do
    let(:converter) { Bioinform::ConversionAlgorithms::PCM2PWMConverter_.new }

    specify { expect(converter.convert(pcm)).to be_kind_of Bioinform::MotifModel::PWM }
    specify { expect(converter.calculate_pseudocount(pcm)).to eq Math.log(10) }

    specify do
      cnt = 10
      k = Math.log(cnt)
      den = 0.25 * (cnt + k)
      expect(converter.convert(pcm).matrix).to eq [
            [Math.log((1+k*0.25)/den), Math.log((2+k*0.25)/den), Math.log((3+k*0.25)/den), Math.log((4+k*0.25)/den)],
            [Math.log((2+k*0.25)/den), Math.log((2+k*0.25)/den), Math.log((2+k*0.25)/den), Math.log((4+k*0.25)/den)] ]
    end

    specify { expect{ converter.convert(pcm_different_counts) }.to raise_error Bioinform::Error }

    specify { expect(converter.convert(named_pcm)).to be_kind_of Bioinform::MotifModel::NamedModel }
    specify { expect(converter.convert(named_pcm).model).to be_kind_of Bioinform::MotifModel::PWM }
    specify { expect(converter.convert(named_pcm).name).to eq 'motif name' }
    specify { expect{ converter.convert(pwm) }.to raise_error Bioinform::Error }
    specify { expect{ converter.convert(named_pwm) }.to raise_error Bioinform::Error }
    specify { expect{ converter.convert(ppm) }.to raise_error Bioinform::Error }
  end

  context 'with specified explicitly pseudocount' do
    let(:specified_pseudocount) { 5 }
    let(:converter) { Bioinform::ConversionAlgorithms::PCM2PWMConverter_.new(pseudocount: specified_pseudocount) }

    specify 'allows PCM-s with different column counts (because pseudocount specified, pcm\'s count not used for pseudocount calculation)' do
      k = specified_pseudocount
      den_1_2 = 0.25 * (10 + k)
      den_3 = 0.25 * (13 + k)
      expect(converter.convert(pcm_different_counts).matrix).to eq [
            [Math.log((1+k*0.25)/den_1_2),  Math.log((2+k*0.25)/den_1_2), Math.log((3+k*0.25)/den_1_2), Math.log((4+k*0.25)/den_1_2)],
            [Math.log((2+k*0.25)/den_1_2),  Math.log((2+k*0.25)/den_1_2), Math.log((2+k*0.25)/den_1_2), Math.log((4+k*0.25)/den_1_2)],
            [Math.log((3+k*0.25)/den_3),    Math.log((3+k*0.25)/den_3),   Math.log((3+k*0.25)/den_3),   Math.log((4+k*0.25)/den_3)] ]
    end
  end

  context 'with specified explicitly background' do
    let(:converter) { Bioinform::ConversionAlgorithms::PCM2PWMConverter_.new(background: Bioinform::Frequencies.new([0.1, 0.4, 0.4, 0.1])) }

    specify 'allows PCM-s with different column counts (because pseudocount specified, pcm\'s count not used for pseudocount calculation)' do
      k = Math.log(10)
      den_at = 0.1 * (10 + k)
      den_cg = 0.4 * (10 + k)
      expect(converter.convert(pcm).matrix).to eq [
            [Math.log((1+k*0.1)/den_at), Math.log((2+k*0.4)/den_cg), Math.log((3+k*0.4)/den_cg), Math.log((4+k*0.1)/den_at)],
            [Math.log((2+k*0.1)/den_at), Math.log((2+k*0.4)/den_cg), Math.log((2+k*0.4)/den_cg), Math.log((4+k*0.1)/den_at)] ]
    end
  end
end
