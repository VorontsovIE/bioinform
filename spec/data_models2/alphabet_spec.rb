require 'bioinform/alphabet'

describe Bioinform::ComplimentableAlphabet do
  specify "should raise if complement's complement is not original letter" do
    expect{ Bioinform::ComplimentableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:B,:A]) }.to raise_error Bioinform::Error
  end

  context 'with correct alphabet' do
    specify{ expect{ Bioinform::ComplimentableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:A,:B]) }.not_to raise_error }
    let(:alphabet) { Bioinform::ComplimentableAlphabet.new([:A,:B,:X,:Y], [:X,:Y,:A,:B]) }
    specify{ expect( alphabet.letter_by_index(2)).to eq :X  }
    specify{ expect( alphabet.index_by_letter(:B)).to eq 1  }
    specify{ expect( alphabet.index_by_letter(:B)).to eq 1  }
    specify{ expect( alphabet.complement_letter(:B)).to eq :Y  }
    specify{ expect( alphabet.complement_index(1)).to eq 3  } # :B --> :Y
  end
end

describe Bioinform::NucleotideAlphabet do
  specify { expect( Bioinform::NucleotideAlphabet.complement_letter(:A) ).to eq :T }
  specify { expect{ Bioinform::NucleotideAlphabet.complement_letter(:N) }.to raise_error Bioinform::Error }

  specify { expect(Bioinform::NucleotideAlphabet.complement_index(0)).to eq 3 }
  specify { expect{Bioinform::NucleotideAlphabet.complement_index(5)}.to raise_error Bioinform::Error}
end

describe Bioinform::IUPACAlphabet do
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
