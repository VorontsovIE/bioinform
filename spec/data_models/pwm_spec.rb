require 'bioinform/data_models/pwm'

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

    specify { expect(pwm.named('motif name')).to be_kind_of Bioinform::MotifModel::NamedModel }
    specify { expect(pwm.named('motif name').model).to eq pwm }
    specify { expect(pwm.named('motif name').name).to eq 'motif name' }

    describe '#score' do
      specify { expect( pwm.score('acT') ).to eq(1 + (-11) + 0.321) }
      specify { expect{ pwm.score('acTt') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('ac') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acW') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acN') }.to raise_error(Bioinform::Error) }
    end

    describe '#reversed, #complemented, #reverse_complemented' do
      specify { expect(pwm.reversed).to be_kind_of Bioinform::MotifModel::PWM }
      specify { expect(pwm.complemented).to be_kind_of Bioinform::MotifModel::PWM }
      specify { expect(pwm.reverse_complemented).to be_kind_of  Bioinform::MotifModel::PWM }
      specify { expect(pwm.revcomp).to be_kind_of             Bioinform::MotifModel::PWM }
    end

    describe '#discreted' do
      specify { expect(pwm.discreted(1)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 1, 1]]) }
      specify { expect(pwm.discreted(1, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 0, 0]]) }
      specify { expect(pwm.discreted(10)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 4]]) }
      specify { expect(pwm.discreted(10, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 3]]) }
      specify { expect(pwm.discreted(10, rounding_method: :floor)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,15],[120,-110,120,0],[-11, 6, 4, 3]]) }
    end

    describe '#left_augmented' do
      specify { expect{pwm.left_augmented(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.left_augmented(0)).to eq pwm }
      specify { expect(pwm.left_augmented(2)).to eq Bioinform::MotifModel::PWM.new( [[0,0,0,0],[0,0,0,0],[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    end
    describe '#right_augmented' do
      specify { expect{pwm.right_augmented(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.right_augmented(0)).to eq pwm }
      specify { expect(pwm.right_augmented(2)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[0,0,0,0],[0,0,0,0]]) }
    end
  end

  context 'with different alphabet' do
                  #  A     C    G    T       M  R  W  S  Y  K   B   D   H   V     N
    let(:matrix) { [[1,    2,   3,   1.567,  10,20,30,40,50,60, 700,800,900,1000, 10000],
                    [12,  -11,  12,  0,      11,21,31,41,51,61, 701,801,901,1001, 10001 ],
                    [-1.1, 0.6, 0.4, 0.321,  12,22,32,42,52,62, 702,802,902,1002, 10002 ]] }
    let(:pwm) { Bioinform::MotifModel::PWM.new(matrix, alphabet: Bioinform::IUPACAlphabet) }
    describe '#score' do
      specify { expect( pwm.score('acT') ).to eq(1 + (-11) + 0.321) }
      specify { expect{ pwm.score('acTt') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('ac') }.to raise_error(Bioinform::Error) }
      specify { expect( pwm.score('acW') ).to eq(1 + (-11) + 32) }
      specify { expect( pwm.score('acN') ).to eq(1 + (-11) + 10002) }
    end
    specify { expect(pwm.left_augmented(1)).to be_kind_of Bioinform::MotifModel::PWM }
    specify { expect(pwm.left_augmented(1).alphabet).to eq Bioinform::IUPACAlphabet }
    specify { expect(pwm.left_augmented(1).matrix).to eq [[0,    0,   0,   0,      0, 0, 0, 0, 0, 0,  0,  0,  0,  0,    0],
                                                        [1,    2,   3,   1.567,  10,20,30,40,50,60, 700,800,900,1000, 10000],
                                                        [12,  -11,  12,  0,      11,21,31,41,51,61, 701,801,901,1001, 10001 ],
                                                        [-1.1, 0.6, 0.4, 0.321,  12,22,32,42,52,62, 702,802,902,1002, 10002 ]] }

    specify { expect(pwm.discreted(1).matrix).to eq [[1, 2, 3, 2,  10,20,30,40,50,60, 700,800,900,1000, 10000],
                                                    [12,-11,12,0,  11,21,31,41,51,61, 701,801,901,1001, 10001 ],
                                                    [-1, 1, 1, 1,  12,22,32,42,52,62, 702,802,902,1002, 10002 ]] }
    specify { expect(pwm.discreted(1).alphabet).to eq Bioinform::IUPACAlphabet}

    specify { expect{ pwm.to_IUPAC_PWM }.to raise_error }
  end
end
