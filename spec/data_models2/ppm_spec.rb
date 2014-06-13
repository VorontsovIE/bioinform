require 'bioinform/data_models_2/ppm'

describe Bioinform::MotifModel::PPM do

  describe '.new' do
    specify 'fails on matrix having negative elements' do
      expect { Bioinform::MotifModel::PPM.new([[0.4, 0.1, 0.1, 0.4],[0.6, -0.1, -0.1, 0.6],[0.25, 0.25, 0.25, 0.25]]) }.to raise_error (Bioinform::Error)
    end
    specify 'fails on matrix having sum of position elements different from 1' do
      expect { Bioinform::MotifModel::PPM.new([[0.4, 0.1, 0.1, 0.4],[0.6, 0.1, 0.1, 0.6],[0.25, 0.25, 0.25, 0.25]]) }.to raise_error (Bioinform::Error)
      expect { Bioinform::MotifModel::PPM.new([[0.4, 0.1, 0.1, 0.4],[0.3, 0.1, 0.1, 0.3],[0.25, 0.25, 0.25, 0.25]]) }.to raise_error (Bioinform::Error)
      expect { Bioinform::MotifModel::PPM.new([[0.3, 0.1, 0.1, 0.3],[0.3, 0.1, 0.1, 0.3],[0.2, 0.2, 0.2, 0.2]]) }.to raise_error (Bioinform::Error)
    end

    context 'with valid matrix' do
      let(:matrix) { [[0.4, 0.1, 0.1, 0.4],[0.3, 0.2, 0.2, 0.3],[0.25, 0.25, 0.25, 0.25]] }
      specify do
        expect { Bioinform::MotifModel::PPM.new(matrix) }.not_to raise_error
      end
      specify do
        expect( Bioinform::MotifModel::PPM.new(matrix).matrix ).to eq matrix
      end
    end
  end

  context 'valid PPM' do
    let(:ppm) { Bioinform::MotifModel::PPM.new(matrix) }
    let(:matrix) { [[0.4, 0.1, 0.1, 0.4],[0.3, 0.2, 0.2, 0.3],[0.25, 0.25, 0.25, 0.25]] }

    specify { expect(ppm).to eq Bioinform::MotifModel::PPM.new(matrix) }
    specify { expect(ppm).not_to eq matrix }
    specify { expect(ppm).not_to eq Bioinform::MotifModel::PM.new(matrix) }
    specify { expect(ppm).not_to eq Bioinform::MotifModel::PWM.new(matrix) }
    specify { expect(ppm).not_to eq Bioinform::MotifModel::PCM.new(matrix) }
    specify { expect(matrix).not_to eq ppm }
    specify { expect(Bioinform::MotifModel::PM.new(matrix)).not_to eq ppm }
    specify { expect(Bioinform::MotifModel::PWM.new(matrix)).not_to eq ppm }
    specify { expect(Bioinform::MotifModel::PCM.new(matrix)).not_to eq ppm }

    describe '#reverse, #complement, #reverse_complement' do
      specify { expect(ppm.reverse).to be_kind_of Bioinform::MotifModel::PPM }
      specify { expect(ppm.complement).to be_kind_of Bioinform::MotifModel::PPM }
      specify { expect(ppm.reverse_complement).to be_kind_of  Bioinform::MotifModel::PPM }
      specify { expect(ppm.revcomp).to be_kind_of             Bioinform::MotifModel::PPM }
    end
  end
end