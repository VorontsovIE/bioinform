require 'bioinform/data_models_2/pcm'

describe Bioinform::MotifModel::PCM do

  describe '.new' do
    specify 'fails on matrix having negative elements' do
      expect { Bioinform::MotifModel::PCM.new([[1,2,1,3],[3,3,0,1], [-2, 3, 3, 3]]) }.to raise_error (Bioinform::Error)
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

  context 'valid PCM' do
    let(:pcm) { Bioinform::MotifModel::PCM.new(matrix) }
    context 'with equal counts in different positions' do
      let(:matrix) { [[1,2,1,3],[3,3,0,1], [1, 0, 3, 3]] }
      specify{ expect(pcm.count).to eq 7 }
    end

    context 'with different counts in different positions' do
      let(:matrix) { [[1,2,1,3],[30,10,100,11000], [1, 0, 3, 3]] }
        specify{ expect{ pcm.count }.to raise_error Bioinform::Error }
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

    describe '#reverse, #complement, #reverse_complement' do
      specify { expect(pcm.reverse).to be_kind_of Bioinform::MotifModel::PCM }
      specify { expect(pcm.complement).to be_kind_of Bioinform::MotifModel::PCM }
      specify { expect(pcm.reverse_complement).to be_kind_of  Bioinform::MotifModel::PCM }
      specify { expect(pcm.revcomp).to be_kind_of             Bioinform::MotifModel::PCM }
    end
  end
end
