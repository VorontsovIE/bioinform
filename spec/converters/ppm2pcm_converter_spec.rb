require 'bioinform/conversion_algorithms/pcm2ppm_converter'

describe Bioinform::ConversionAlgorithms::PPM2PCMConverter do
  let(:pcm) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:pwm) { Bioinform::MotifModel::PWM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:ppm) { Bioinform::MotifModel::PPM.new([[0.1,0.2,0.3,0.4],[0.2,0.2,0.2,0.4]]) }

  let(:named_ppm) { Bioinform::MotifModel::NamedModel.new(ppm, 'motif name') }
  let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
  let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }

  let(:converter) { Bioinform::ConversionAlgorithms::PPM2PCMConverter.new }
  let(:converter_explicit_count) { Bioinform::ConversionAlgorithms::PPM2PCMConverter.new(count: 10) }

  specify { expect(converter.count).to eq 100 }
  specify { expect(converter_explicit_count.count).to eq 10 }

  specify { expect(converter.convert(ppm)).to be_kind_of Bioinform::MotifModel::PCM }

  specify { expect(converter.convert(ppm).matrix).to eq [[10,20,30,40],[20,20,20,40]] }

  specify { expect(converter_explicit_count.convert(ppm).matrix).to eq [[1,2,3,4],[2,2,2,4]] }

  specify { expect(converter.convert(named_ppm)).to be_kind_of Bioinform::MotifModel::NamedModel }
  specify { expect(converter.convert(named_ppm).model).to be_kind_of Bioinform::MotifModel::PCM }
  specify { expect(converter.convert(named_ppm).name).to eq 'motif name' }

  specify { expect{ converter.convert(pcm) }.to raise_error Bioinform::Error }
  specify { expect{ converter.convert(pwm) }.to raise_error Bioinform::Error }
  specify { expect{ converter.convert(named_pcm) }.to raise_error Bioinform::Error }
  specify { expect{ converter.convert(named_pwm) }.to raise_error Bioinform::Error }
end
