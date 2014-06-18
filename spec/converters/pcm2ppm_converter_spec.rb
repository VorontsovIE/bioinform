require 'bioinform/conversion_algorithms/pcm2ppm_converter'

describe Bioinform::ConversionAlgorithms::PCM2PPMConverter do
  let(:pcm) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:pwm) { Bioinform::MotifModel::PWM.new([[1,2,3,4],[2,2,2,4]]) }
  let(:ppm) { Bioinform::MotifModel::PPM.new([[0.1,0.2,0.3,0.4],[0.2,0.2,0.2,0.4]]) }
  let(:pcm_different_counts) { Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4],[3,3,3,4]]) }

  let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
  let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }

  let(:converter) { Bioinform::ConversionAlgorithms::PCM2PPMConverter.new }

  specify { expect(converter.convert(pcm)).to be_kind_of Bioinform::MotifModel::PPM }

  specify do
    expect(converter.convert(pcm).matrix).to eq [ [0.1,0.2,0.3,0.4],
                                                  [0.2,0.2,0.2,0.4] ]
  end
  specify do
    expect(converter.convert(pcm_different_counts).matrix).to eq [ [0.1,0.2,0.3,0.4],
                                                                   [0.2,0.2,0.2,0.4],
                                                                   [3.0/13, 3.0/13, 3.0/13, 4.0/13] ]
  end

  specify { expect(converter.convert(named_pcm)).to be_kind_of Bioinform::MotifModel::NamedModel }
  specify { expect(converter.convert(named_pcm).model).to be_kind_of Bioinform::MotifModel::PPM }
  specify { expect(converter.convert(named_pcm).name).to eq 'motif name' }
  specify { expect{ converter.convert(pwm) }.to raise_error Bioinform::Error }
  specify { expect{ converter.convert(named_pwm) }.to raise_error Bioinform::Error }
  specify { expect{ converter.convert(ppm) }.to raise_error Bioinform::Error }
end
