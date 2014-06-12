require 'bioinform/data_models_2/pm'

describe Bioinform::MotifModel::PM do

  describe '.new' do
    specify 'with matrix having more than 4 elements in a position' do
      expect { Bioinform::MotifModel::PM.new([[1,2,3,1.567],[10,11,12,15,10],[-1.1, 0.6, 0.4, 0.321]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with matrix having less than 4 elements in a position' do
      expect { Bioinform::MotifModel::PM.new([[1,2,3,1.567],[10,11,12,15],[-1.1, 0.6]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with matrix having positions in rows, nucleotides in columns' do
      expect { Bioinform::MotifModel::PM.new([[1,2,3],[10,-11,12],[-1.1, 0.6, 0.4],[5,6,7]]) }.to raise_error (Bioinform::Error)
    end

    specify 'with empty matrix' do
      expect { Bioinform::MotifModel::PM.new([]) }.to raise_error (Bioinform::Error)
    end

    context 'with valid matrix' do
      let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }

      specify do
        expect{ Bioinform::MotifModel::PM.new(matrix) }.not_to raise_error
      end
      specify do
        expect( Bioinform::MotifModel::PM.new(matrix).matrix ).to eq matrix
      end
    end
  end

  context 'valid PM' do
    let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
    let(:pm) { Bioinform::MotifModel::PM.new(matrix) }
    specify { expect( pm.length ).to eq 3 }

    specify { expect(pm.to_s).to eq("1\t2\t3\t1.567\n"+"12\t-11\t12\t0\n"+"-1.1\t0.6\t0.4\t0.321") }

    specify { expect(pm.consensus).to eq "GRC" }

    specify { expect(pm).to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    specify { expect(pm).not_to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[1, 2, 3, 4]]) }
    specify { expect(pm).not_to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]]) }
    specify { expect(pm).not_to eq [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]] }

    describe '#reverse, #complement, #reverse_complement' do
      specify { expect(pm.reverse.matrix).to eq [[-1.1, 0.6, 0.4, 0.321],[12,-11,12,0],[1,2,3,1.567]] }
      specify { expect(pm.complement.matrix).to eq [[1.567,3,2,1],[0,12,-11,12],[0.321,0.4,0.6,-1.1]] }
      specify { expect(pm.reverse_complement.matrix).to eq [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
      specify { expect(pm.revcomp.matrix).to eq            [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
      specify { expect(pm.reverse).to be_kind_of Bioinform::MotifModel::PM }
      specify { expect(pm.complement).to be_kind_of Bioinform::MotifModel::PM }
      specify { expect(pm.reverse_complement).to be_kind_of  Bioinform::MotifModel::PM }
      specify { expect(pm.revcomp).to be_kind_of             Bioinform::MotifModel::PM }
    end

    specify { expect{|b| pm.each_position(&b) }.to yield_successive_args([1,2,3,1.567], [12,-11,12,0], [-1.1, 0.6, 0.4, 0.321]) }
    specify { expect(pm.each_position).to be_kind_of Enumerator }
    specify { expect{|b| pm.each_position.each(&b) }.to yield_successive_args([1,2,3,1.567], [12,-11,12,0], [-1.1, 0.6, 0.4, 0.321]) }
  end
end
