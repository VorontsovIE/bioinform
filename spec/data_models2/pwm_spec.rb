require 'bioinform/data_models_2/pwm'

describe Bioinform::MotifModel::PWM do

  describe '.new' do
    context 'with valid matrix' do
      let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }

      specify do
        expect { Bioinform::MotifModel::PWM.new(matrix) }.not_to raise_error
      end
      specify do
        expect( Bioinform::MotifModel::PWM.new(matrix).matrix ).to eq matrix
      end
    end
  end

  context 'valid PWM' do
    let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
    let(:pwm) { Bioinform::MotifModel::PWM.new(matrix) }

    specify { expect(pwm).to eq Bioinform::MotifModel::PWM.new(matrix) }
    specify { expect(pwm).not_to eq matrix }
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PM.new(matrix) }
    # specify { expect(pwm).not_to eq Bioinform::MotifModel::PCM.new(matrix) }
    # specify { expect(pwm).not_to eq Bioinform::MotifModel::PPM.new(matrix) }
    specify { expect(matrix).not_to eq pwm }
    specify { expect(Bioinform::MotifModel::PM.new(matrix)).not_to eq pwm }
    # specify { expect(Bioinform::MotifModel::PCM.new(matrix)).not_to eq pwm }
    # specify { expect(Bioinform::MotifModel::PPM.new(matrix)).not_to eq pwm }

    describe '#score' do
      specify { expect( pwm.score('acT') ).to eq(1 + (-11) + 0.321) }
      specify { expect{ pwm.score('acTt') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('ac') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acW') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acN') }.to raise_error(Bioinform::Error) }
    end

    describe '#reverse, #complement, #reverse_complement' do
      specify { expect(pwm.reverse).to be_kind_of Bioinform::MotifModel::PWM }
      specify { expect(pwm.complement).to be_kind_of Bioinform::MotifModel::PWM }
      specify { expect(pwm.reverse_complement).to be_kind_of  Bioinform::MotifModel::PWM }
      specify { expect(pwm.revcomp).to be_kind_of             Bioinform::MotifModel::PWM }
    end

    describe '#discreted' do
      specify { expect(pwm.discreted(1)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 1, 1]]) }
      specify { expect(pwm.discreted(1, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 0, 0]]) }
      specify { expect(pwm.discreted(10)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 4]]) }
      specify { expect(pwm.discreted(10, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 3]]) }
      specify { expect(pwm.discreted(10, rounding_method: :floor)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,15],[120,-110,120,0],[-11, 6, 4, 3]]) }
    end

    describe '#left_augment' do
      specify { expect{pwm.left_augment(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.left_augment(0)).to eq pwm }
      specify { expect(pwm.left_augment(2)).to eq Bioinform::MotifModel::PWM.new( [[0,0,0,0],[0,0,0,0],[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    end
    describe '#right_augment' do
      specify { expect{pwm.right_augment(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.right_augment(0)).to eq pwm }
      specify { expect(pwm.right_augment(2)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[0,0,0,0],[0,0,0,0]]) }
    end

  end
end
