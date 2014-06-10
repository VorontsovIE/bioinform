require 'bioinform/data_models_2/pwm'

describe Bioinform::MotifModel::PWM do

  describe '.new' do
    specify 'with matrix having more than 4 elements in a position' do
      expect { Bioinform::MotifModel::PWM.new([[1,2,3,1.567],[10,11,12,15,10],[-1.1, 0.6, 0.4, 0.321]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with matrix having less than 4 elements in a position' do
      expect { Bioinform::MotifModel::PWM.new([[1,2,3,1.567],[10,11,12,15],[-1.1, 0.6]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with matrix having positions in rows, nucleotides in columns' do
      expect { Bioinform::MotifModel::PWM.new([[1,2,3],[10,-11,12],[-1.1, 0.6, 0.4],[5,6,7]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with empty matrix' do
      expect { Bioinform::MotifModel::PWM.new([]) }.to raise_error (Bioinform::Error)
    end

    context 'with valid matrix' do
      let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }

      specify do
        expect { Bioinform::MotifModel::PWM.new(matrix) }.not_to raise_error
      end
      specify do
        expect( Bioinform::MotifModel::PWM.new(matrix).matrix ).to eq matrix
      end
      context 'without name' do
        specify do
          expect( Bioinform::MotifModel::PWM.new(matrix).matrix ).to eq matrix
        end
        specify do
          expect( Bioinform::MotifModel::PWM.new(matrix).name ).to be_nil
        end
      end
      context 'with name' do
        specify do
          expect( Bioinform::MotifModel::PWM.new(matrix).matrix ).to eq matrix
        end
        specify do
          expect( Bioinform::MotifModel::PWM.new(matrix, name: 'Motif name').name ).to eq 'Motif name'
        end
      end
    end
  end
  
  context 'valid PWM' do
    let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
    let(:name) { 'Motif name' }
    subject(:pwm) { Bioinform::MotifModel::PWM.new(matrix, name: name) }
    specify { expect( pwm.length ).to eq 3 }
    
    # What about ">Motif name" as in FASTA
    specify { expect(pwm.to_s).to eq("Motif name\n"+"1\t2\t3\t1.567\n"+"12\t-11\t12\t0\n"+"-1.1\t0.6\t0.4\t0.321") }

    specify { expect(pwm.consensus).to eq "GRC" }

    describe '#score' do
      specify { expect( pwm.score('acT') ).to eq(1 + (-11) + 0.321) }
      specify { expect{ pwm.score('acTt') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('ac') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acW') }.to raise_error(Bioinform::Error) }
      specify { expect{ pwm.score('acN') }.to raise_error(Bioinform::Error) }
    end

    specify { expect(pwm).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]], name: name) }
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    specify { expect(pwm).not_to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]], name: name) }
    
    specify { expect(pwm.reverse).to eq Bioinform::MotifModel::PWM.new( [[-1.1, 0.6, 0.4, 0.321],[12,-11,12,0],[1,2,3,1.567]], name: name) }
    specify { expect(pwm.complement).to eq Bioinform::MotifModel::PWM.new( [[1.567,3,2,1],[0,12,-11,12],[0.321,0.4,0.6,-1.1]], name: name) }
    specify { expect(pwm.reverse_complement).to eq  Bioinform::MotifModel::PWM.new( [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]], name: name) }
    specify { expect(pwm.revcomp).to eq             Bioinform::MotifModel::PWM.new( [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]], name: name) }
    
    describe '#discreted' do
      specify { expect(pwm.discreted(1)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 1, 1]], name: name) }
      specify { expect(pwm.discreted(1, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,2],[12,-11,12,0],[-1, 1, 0, 0]], name: name) }
      specify { expect(pwm.discreted(10)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 4]], name: name) }
      specify { expect(pwm.discreted(10, rounding_method: :round)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,16],[120,-110,120,0],[-11, 6, 4, 3]], name: name) }
      specify { expect(pwm.discreted(10, rounding_method: :floor)).to eq Bioinform::MotifModel::PWM.new( [[10,20,30,15],[120,-110,120,0],[-11, 6, 4, 3]], name: name) }
    end

    describe '#left_augment' do
      specify { expect{pwm.left_augment(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.left_augment(0)).to eq pwm }
      specify { expect(pwm.left_augment(2)).to eq Bioinform::MotifModel::PWM.new( [[0,0,0,0],[0,0,0,0],[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]], name: name) }
    end
    describe '#right_augment' do
      specify { expect{pwm.right_augment(-1)}.to raise_error Bioinform::Error }
      specify { expect(pwm.right_augment(0)).to eq pwm }
      specify { expect(pwm.right_augment(2)).to eq Bioinform::MotifModel::PWM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[0,0,0,0],[0,0,0,0]], name: name) }
    end

    specify { expect{|b| pwm.each_position(&b) }.to yield_successive_args([1,2,3,1.567], [12,-11,12,0], [-1.1, 0.6, 0.4, 0.321]) }
  end
end
