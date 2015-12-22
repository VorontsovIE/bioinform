require 'bioinform/data_models/pcm'

describe Bioinform::MotifModel::PCM do

  describe '.new' do
    specify 'fails on matrix having negative elements' do
      expect { Bioinform::MotifModel::PCM.new([[1,2,1,3],[3,3,0,1], [-2, 3, 3, 3]]) }.to raise_error(Bioinform::Error)
    end

    context 'with valid matrix' do
      context 'with equal counts in different positions' do
        let(:matrix) { [[1,2,1,3],[3,3,0,1], [1, 0, 3, 3]] }
        specify do
          expect { Bioinform::MotifModel::PCM.new(matrix) }.not_to raise_error
        end
        specify do
          expect( Bioinform::MotifModel::PCM.new(matrix).matrix ).to eq matrix
        end
      end

      context 'with different counts in different positions' do
        let(:matrix) { [[1,2,1,3],[30,10,100,11000], [1, 0, 3, 3]] }
        specify do
          expect { Bioinform::MotifModel::PCM.new(matrix) }.not_to raise_error
        end
        specify do
          expect( Bioinform::MotifModel::PCM.new(matrix).matrix ).to eq matrix
        end
      end
    end
  end

  describe '.from_string' do
    specify {
      expect( Bioinform::MotifModel::PCM.from_string("1 2 3 4\n4 2 2 2").model.class ).to eq Bioinform::MotifModel::PCM
    }
  end

  context 'valid PCM' do
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    context 'with equal counts in different positions' do
      let(:matrix) { [[1,2,1,3],[3,3,0,1], [1, 0, 3, 3]] }
      specify{ expect(pcm.count).to eq 7 }
    end

    context 'with different counts in different positions' do
      let(:matrix) { [[1,2,1,3],[30,10,100,11000], [1, 0, 3, 3]] }
        specify{ expect{ pcm.count }.to raise_error(Bioinform::Error) }
    end
  end

  context 'valid PCM' do
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    let(:matrix) { [[1,2,1,3],[3,3,0,1], [1, 0, 3, 3]] }

    specify { expect(pcm).to eq Bioinform::MotifModel::PCM.new(matrix) }
    specify { expect(pcm).not_to eq matrix }
    specify { expect(pcm).not_to eq Bioinform::MotifModel::PM.new(matrix) }
    specify { expect(pcm).not_to eq Bioinform::MotifModel::PWM.new(matrix) }
    # specify { expect(pcm).not_to eq Bioinform::MotifModel::PPM.new(matrix) }
    specify { expect(matrix).not_to eq pcm }
    specify { expect(Bioinform::MotifModel::PM.new(matrix)).not_to eq pcm }
    specify { expect(Bioinform::MotifModel::PWM.new(matrix)).not_to eq pcm }
    # specify { expect(Bioinform::MotifModel::PPM.new(matrix)).not_to eq pcm }

    specify { expect(pcm.named('motif name')).to be_kind_of Bioinform::MotifModel::NamedModel }
    specify { expect(pcm.named('motif name').model).to eq pcm }
    specify { expect(pcm.named('motif name').name).to eq 'motif name' }

    describe '#reversed, #complemented, #reverse_complemented' do
      specify { expect(pcm.reversed).to be_kind_of Bioinform::MotifModel::PCM }
      specify { expect(pcm.complemented).to be_kind_of Bioinform::MotifModel::PCM }
      specify { expect(pcm.reverse_complemented).to be_kind_of  Bioinform::MotifModel::PCM }
      specify { expect(pcm.revcomp).to be_kind_of             Bioinform::MotifModel::PCM }
    end
  end

  describe '.acts_as_pcm?' do
    let(:matrix) { [[0.1,0.2,0.3,0.4],[0.3,0.3,0.3,0.1], [0.3,0,0.3,0.4]] }
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    let(:pwm) { Bioinform::MotifModel::PWM.new(matrix) }
    let(:ppm) { Bioinform::MotifModel::PPM.new(matrix) }
    let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
    let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }
    let(:named_ppm) { Bioinform::MotifModel::NamedModel.new(ppm, 'motif name') }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(pcm)).to be_truthy }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(named_pcm)).to be_truthy }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(pwm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(named_pwm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(ppm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pcm?(named_ppm)).to be_falsy }
  end

  describe '.acts_as_pwm?' do
    let(:matrix) { [[0.1,0.2,0.3,0.4],[0.3,0.3,0.3,0.1], [0.3,0,0.3,0.4]] }
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    let(:pwm) { Bioinform::MotifModel::PWM.new(matrix) }
    let(:ppm) { Bioinform::MotifModel::PPM.new(matrix) }
    let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
    let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }
    let(:named_ppm) { Bioinform::MotifModel::NamedModel.new(ppm, 'motif name') }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(pcm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(named_pcm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(pwm)).to be_truthy }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(named_pwm)).to be_truthy }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(ppm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_pwm?(named_ppm)).to be_falsy }
  end

  describe '.acts_as_ppm?' do
    let(:matrix) { [[0.1,0.2,0.3,0.4],[0.3,0.3,0.3,0.1], [0.3,0,0.3,0.4]] }
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    let(:pwm) { Bioinform::MotifModel::PWM.new(matrix) }
    let(:ppm) { Bioinform::MotifModel::PPM.new(matrix) }
    let(:named_pcm) { Bioinform::MotifModel::NamedModel.new(pcm, 'motif name') }
    let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, 'motif name') }
    let(:named_ppm) { Bioinform::MotifModel::NamedModel.new(ppm, 'motif name') }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(pcm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(named_pcm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(pwm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(named_pwm)).to be_falsy }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(ppm)).to be_truthy }
    specify{ expect(Bioinform::MotifModel.acts_as_ppm?(named_ppm)).to be_truthy }
  end
end
