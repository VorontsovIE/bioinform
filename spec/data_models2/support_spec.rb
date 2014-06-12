require 'bioinform/support'

describe Bioinform::Support do
  specify do
    expect(Bioinform::Support.element_indices([:A,:C,:G,:T])).to eq( {:A=>0, :C=>1, :G=>2, :T=>3} )
  end

  specify do
    expect(Bioinform::Support.hash_keys_permuted([0,1], :A)).to eq( {[0,1] => :A, [1,0] => :A} )
  end

  specify do
    expect(Bioinform::Support.with_key_permutations({[0,1] => :A, [0,2] => :T})).to eq( {[0,1] => :A, [1,0] => :A, [0,2] => :T, [2,0]=>:T} )
  end
end
