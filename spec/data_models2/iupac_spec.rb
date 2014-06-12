require 'bioinform/iupac'

describe Bioinform::IUPAC do
  specify do
    expect(Bioinform::IUPAC.element_indices([:A,:C,:G,:T])).to eq( {:A=>0, :C=>1, :G=>2, :T=>3} )
  end

  specify do
    expect(Bioinform::IUPAC.hash_keys_permuted([0,1], :A)).to eq( {[0,1] => :A, [1,0] => :A} )
  end

  specify do
    expect(Bioinform::IUPAC.with_key_permutations({[0,1] => :A, [0,2] => :T})).to eq( {[0,1] => :A, [1,0] => :A, [0,2] => :T, [2,0]=>:T} )
  end

  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:A) ).to eq :T }
  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:N) ).to eq :N }
  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:R) ).to eq :Y } # R = AG; Y = CT
  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:Y) ).to eq :R }
  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:W) ).to eq :W } # W = AT
  specify { expect( Bioinform::IUPAC.complement_iupac_letter(:V) ).to eq :B } # V = ACG; B = CGT

  specify { expect(Bioinform::IUPAC.complement_iupac_index(0)).to eq 3 }
  specify { expect(Bioinform::IUPAC.complement_iupac_index(14)).to eq 14 } # N --> 4
  specify { expect(Bioinform::IUPAC.complement_iupac_index(5)).to eq 8 } # R --> 5; Y --> 8
end
