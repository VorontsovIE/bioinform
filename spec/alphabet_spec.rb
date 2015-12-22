require 'bioinform/alphabet'

describe Bioinform::ComplementableAlphabet do
  specify "should raise if complement's complement is not original letter" do
    expect{ Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:B,:A]) }.to raise_error(Bioinform::Error)
    expect{ Bioinform::ComplementableAlphabet.new([:A,:B,:B,:C], [:C,:B,:B,:A]) }.to raise_error(Bioinform::Error)
    expect{ Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:B,:A,:C]) }.to raise_error(Bioinform::Error)
  end

  context 'usage with alphabet non-symbolized, non-upcased' do
    let(:alphabet) { Bioinform::ComplementableAlphabet.new([:a,:B,'x','Y'], ['X',:y,:A,'B']) }

    specify{ expect(alphabet.alphabet).to eq [:A,:B,:X,:Y]  }
    specify{ expect(alphabet.complement_letter(:A)).to eq :X  }
    specify{ expect(alphabet.complement_letter(:x)).to eq :a  }
    specify{ expect(alphabet.complement_letter('B')).to eq 'Y'  }
    specify{ expect(alphabet.complement_letter('b')).to eq 'y'  }

    specify{ expect(alphabet.index_by_letter(:B)).to eq 1  }
    specify{ expect(alphabet.index_by_letter(:b)).to eq 1  }
    specify{ expect(alphabet.index_by_letter('B')).to eq 1  }
    specify{ expect(alphabet.index_by_letter('b')).to eq 1  }
  end

  context 'with correct alphabet' do
    specify{ expect{ Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:A,:B]) }.not_to raise_error }
    let(:alphabet) { Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:A,:B]) }

    specify{ expect(alphabet).to eq Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:A,:B]) }
    specify{ expect(alphabet).not_to eq Bioinform::ComplementableAlphabet.new([:A,:C,:X,:Y], [:X,:Y,:A,:C]) }
    specify{ expect(alphabet).not_to eq Bioinform::ComplementableAlphabet.new([:A,:B,:X,:Y], [:Y,:X,:B,:A]) }
    specify{ expect(alphabet).not_to eq Bioinform::ComplementableAlphabet.new([:B,:A,:Y,:X], [:X,:Y,:A,:B]) }

    specify{ expect(alphabet.alphabet).to eq [:A,:B,:X,:Y]  }
    specify{ expect(alphabet.complement_alphabet).to eq [:X,:Y,:A,:B]  }
    specify{ expect(alphabet.letter_by_index(2)).to eq :X  }

    specify{ expect(alphabet.complement_index(1)).to eq 3  } # :B --> :Y

    specify{ expect{|b| alphabet.each_letter(&b) }.to yield_successive_args(:A,:B,:X,:Y) }
    specify{ expect{|b| alphabet.each_letter.each(&b) }.to yield_successive_args(:A,:B,:X,:Y) }
    specify{ expect{|b| alphabet.each_letter_index(&b) }.to yield_successive_args(0,1,2,3) }
    specify{ expect{|b| alphabet.each_letter_index.each(&b) }.to yield_successive_args(0,1,2,3) }
  end
end

describe Bioinform::NucleotideAlphabet do
  specify { expect( Bioinform::NucleotideAlphabet.size ).to eq 4 }
  specify { expect( Bioinform::NucleotideAlphabet.complement_letter(:A) ).to eq :T }
  specify { expect( Bioinform::NucleotideAlphabet.complement_letter(:C) ).to eq :G }
  specify { expect{ Bioinform::NucleotideAlphabet.complement_letter(:N) }.to raise_error(Bioinform::Error) }

  specify { expect(Bioinform::NucleotideAlphabet.complement_index(0)).to eq 3 }
  specify { expect{Bioinform::NucleotideAlphabet.complement_index(4)}.to raise_error(Bioinform::Error)}
end

describe Bioinform::NucleotideAlphabetWithN do
  specify { expect( Bioinform::NucleotideAlphabetWithN.size ).to eq 5 }
  specify { expect( Bioinform::NucleotideAlphabetWithN.complement_letter(:A) ).to eq :T }
  specify { expect( Bioinform::NucleotideAlphabetWithN.complement_letter(:C) ).to eq :G }
  specify { expect( Bioinform::NucleotideAlphabetWithN.complement_letter(:N) ).to eq :N }

  specify { expect( Bioinform::NucleotideAlphabetWithN.complement_index(0) ).to eq 3 }
  specify { expect( Bioinform::NucleotideAlphabetWithN.complement_index(4) ).to eq 4 }
end

describe Bioinform::IUPACAlphabet do
  specify { expect( Bioinform::IUPACAlphabet.size ).to eq 15 }
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:A) ).to eq :T }
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:N) ).to eq :N }
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:R) ).to eq :Y } # R = AG; Y = CT
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:Y) ).to eq :R }
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:W) ).to eq :W } # W = AT
  specify { expect( Bioinform::IUPACAlphabet.complement_letter(:V) ).to eq :B } # V = ACG; B = CGT

  specify { expect(Bioinform::IUPACAlphabet.complement_index(0)).to eq 3 }
  specify { expect(Bioinform::IUPACAlphabet.complement_index(14)).to eq 14 } # N --> 4
  specify { expect(Bioinform::IUPACAlphabet.complement_index(5)).to eq 8 } # R --> 5; Y --> 8
end
