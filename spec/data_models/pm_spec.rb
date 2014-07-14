require 'bioinform/data_models/pm'

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
      specify do
        expect( Bioinform::MotifModel::PM.new(matrix).alphabet ).to eq Bioinform::NucleotideAlphabet
      end
    end
  end

  describe '.from_string' do
    specify {
      expect( Bioinform::MotifModel::PM.from_string("1 2 3 4\n5 6 7 8").model.class ).to eq Bioinform::MotifModel::PM
    }
    specify {
      expect( Bioinform::MotifModel::PM.from_string("1 2 3 4\n5 6 7 8").name ).to be_nil
    }
    specify {
      expect( Bioinform::MotifModel::PM.from_string("1 2 3 4\n5 6 7 8").matrix ).to eq [[1,2,3,4],[5,6,7,8]]
    }
    specify {
      expect( Bioinform::MotifModel::PM.from_string("1 2 3 4\n5 6 7 8") ).to be_kind_of Bioinform::MotifModel::NamedModel
    }

    specify {
      expect( Bioinform::MotifModel::PM.from_string(">Motif name\n1 2 3 4\n5 6 7 8").name ).to eq 'Motif name'
    }
    specify {
      expect( Bioinform::MotifModel::PM.from_string(">Motif name\n1 2 3 4\n5 6 7 8").matrix ).to eq [[1,2,3,4],[5,6,7,8]]
    }
    specify {
      expect( Bioinform::MotifModel::PM.from_string(">Motif name\n1 2 3 4\n5 6 7 8") ).to be_kind_of Bioinform::MotifModel::NamedModel
    }

    context 'with custom parser' do
      let(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows) }
      specify{
        expect( Bioinform::MotifModel::PM.from_string("1 5\n2 6\n3 7\n4 8", parser: parser).matrix ).to eq [[1,2,3,4],[5,6,7,8]]
      }
    end
    context 'with custom alphabet' do
      let(:alphabet) { Bioinform::NucleotideAlphabetWithN }
      let(:parser) { Bioinform::MatrixParser.new(fix_nucleotides_number: alphabet.size) }
      specify {
        expect( Bioinform::MotifModel::PM.from_string("1 2 3 4 10\n5 6 7 8 100", alphabet: alphabet, parser: parser).matrix ).to eq [[1,2,3,4,10],[5,6,7,8,100]]
      }
      specify {
        expect( Bioinform::MotifModel::PM.from_string("1 2 3 4 10\n5 6 7 8 100", alphabet: alphabet, parser: parser).alphabet ).to eq alphabet
      }
    end
  end

  context 'with different alphabet' do
    let(:matrix_4) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
    let(:matrix_15) { [[1,2,3,1.567,  12,-11,12,0,-1.1,0.6,  0.4,0.321,0.11,-1.23, 2.0],
                       [0,0,0,0,       0,0,0,0,0,0, 0,0,0,0, 0]] }
    specify do
      expect{ Bioinform::MotifModel::PM.new(matrix_4, alphabet: Bioinform::IUPACAlphabet) }.to raise_error Bioinform::Error
    end
    specify do
      expect{ Bioinform::MotifModel::PM.new(matrix_15, alphabet: Bioinform::IUPACAlphabet) }.not_to raise_error
    end

    let(:iupac_pm) { Bioinform::MotifModel::PM.new(matrix_15, alphabet: Bioinform::IUPACAlphabet) }
    specify { expect(iupac_pm.matrix).to eq matrix_15 }
    specify { expect(iupac_pm.alphabet).to eq Bioinform::IUPACAlphabet }

    #                                                    A C G T       AC    AG   AT   CG   CT   GT       ACG    ACT   AGT   CGT     ACGT
    #                                                    1,2,3,1.567,  12,  -11,  12,  0,  -1.1, 0.6,     0.4,   0.321,0.11,-1.23,    2.0
    specify { expect(iupac_pm.complemented.matrix).to eq [[1.567,3,2,1,  0.6, -1.1, 12,  0,  -11,  12,      -1.23, 0.11,0.321,0.4,      2.0],
                                                        [0,0,0,0,       0,0,0,0,0,0,                       0,0,0,0,                   0]] }
    specify { expect(iupac_pm.complemented.alphabet).to eq Bioinform::IUPACAlphabet }

    specify { expect(iupac_pm.reversed.matrix).to eq [[0,0,0,0,       0,0,0,0,0,0, 0,0,0,0, 0],
                                                      [1,2,3,1.567,  12,-11,12,0,-1.1,0.6,  0.4,0.321,0.11,-1.23, 2.0]] }
    specify { expect(iupac_pm.reversed.alphabet).to eq Bioinform::IUPACAlphabet }

    specify { expect(iupac_pm.reverse_complemented.alphabet).to eq Bioinform::IUPACAlphabet }
    specify { expect(iupac_pm.reverse_complemented.matrix).to eq  [[0,0,0,0,       0,0,0,0,0,0,                       0,0,0,0,                   0],
                                                                [1.567,3,2,1,  0.6, -1.1, 12,  0,  -11,  12,      -1.23, 0.11,0.321,0.4,      2.0]] }

  end

  context 'valid PM' do
    let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
    let(:pm) { Bioinform::MotifModel::PM.new(matrix) }
    specify { expect( pm.length ).to eq 3 }

    specify { expect(pm.to_s).to eq("1\t2\t3\t1.567\n"+"12\t-11\t12\t0\n"+"-1.1\t0.6\t0.4\t0.321") }

    specify { expect(pm).to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]]) }
    specify { expect(pm).not_to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]], alphabet: Bioinform::ComplementableAlphabet.new([:A,:B,:C,:D],[:D,:C,:B,:A])) }
    specify { expect(pm).not_to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321],[1, 2, 3, 4]]) }
    specify { expect(pm).not_to eq Bioinform::MotifModel::PM.new( [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]]) }
    specify { expect(pm).not_to eq [[1,2,3,1.567],[12,-11,12,0],[1, 2, 3, 4]] }

    specify { expect(pm.named('motif name')).to be_kind_of Bioinform::MotifModel::NamedModel }
    specify { expect(pm.named('motif name').model).to eq pm }
    specify { expect(pm.named('motif name').name).to eq 'motif name' }

    describe '#reversed, #complemented, #reverse_complemented' do
      specify { expect(pm.reversed.matrix).to eq [[-1.1, 0.6, 0.4, 0.321],[12,-11,12,0],[1,2,3,1.567]] }
      specify { expect(pm.complemented.matrix).to eq [[1.567,3,2,1],[0,12,-11,12],[0.321,0.4,0.6,-1.1]] }
      specify { expect(pm.reverse_complemented.matrix).to eq [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
      specify { expect(pm.revcomp.matrix).to eq            [[0.321,0.4,0.6,-1.1],[0,12,-11,12],[1.567,3,2,1]] }
      specify { expect(pm.reversed).to be_kind_of Bioinform::MotifModel::PM }
      specify { expect(pm.complemented).to be_kind_of Bioinform::MotifModel::PM }
      specify { expect(pm.reverse_complemented).to be_kind_of  Bioinform::MotifModel::PM }
      specify { expect(pm.revcomp).to be_kind_of             Bioinform::MotifModel::PM }
    end

    specify { expect{|b| pm.each_position(&b) }.to yield_successive_args([1,2,3,1.567], [12,-11,12,0], [-1.1, 0.6, 0.4, 0.321]) }
    specify { expect(pm.each_position).to be_kind_of Enumerator }
    specify { expect{|b| pm.each_position.each(&b) }.to yield_successive_args([1,2,3,1.567], [12,-11,12,0], [-1.1, 0.6, 0.4, 0.321]) }
  end
end
