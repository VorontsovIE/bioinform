require 'bioinform/data_models_2/pwm'

describe Bioinform::MotifModel::PWM do

  describe '.new' do
    # # Already tested in PM
    # specify 'with matrix having more than 4 elements in a position' do
    #   expect { Bioinform::MotifModel::PWM.new([[1,2,3,1.567],[10,11,12,15,10],[-1.1, 0.6, 0.4, 0.321]]) }.to raise_error (Bioinform::Error)
    # end

    # specify 'with matrix having less than 4 elements in a position' do
    #   expect { Bioinform::MotifModel::PWM.new([[1,2,3,1.567],[10,11,12,15],[-1.1, 0.6]]) }.to raise_error (Bioinform::Error)
    # end

    # specify 'with matrix having positions in rows, nucleotides in columns' do
    #   expect { Bioinform::MotifModel::PWM.new([[1,2,3],[10,-11,12],[-1.1, 0.6, 0.4],[5,6,7]]) }.to raise_error (Bioinform::Error)
    # end

    # specify 'with empty matrix' do
    #   expect { Bioinform::MotifModel::PWM.new([]) }.to raise_error (Bioinform::Error)
    # end

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
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PM.new(matrix) }
    specify { expect(Bioinform::MotifModel::PM.new(matrix)).not_to eq pwm }

    describe '#score' do
      specify { expect( pwm.score('acT') ).to eq(1 + (-11) + 0.321) }
      specify { expect{ pwm.score('acTt') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('ac') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acW') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acN') }.to raise_error(Bioinform::Error) }
    end

    specify { expect(pwm).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[1, 2, 3, 4]]) }
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]]) }
    specify { expect(pwm).not_to eq [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]] }

    describe '#reverse, #complement, #reverse_complement' do
      # # Already checked in PM
      # specify { expect(pwm.reverse.matrix).to eq [[-1.1, 0.6, 0.4, 0.321],[12,-11,12,0],[1,2,3,1.567]] }
      # specify { expect(pwm.complement.matrix).to eq [[1.567,3,2,1],[0,12,-11,12],[0.321,0.4,0.6,-1.1]] }
      # specify { expect(pwm.reverse_complement.matrix).to eq [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
      # specify { expect(pwm.revcomp.matrix).to eq            [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
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
