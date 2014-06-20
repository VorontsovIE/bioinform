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

  specify do
    expect(Bioinform::Support.various_key_cases({'a' => 2, 'C' => 3, :g =>5, :T => 8})).to eq( {'a' => 2, 'A' => 2, 'c' => 3, 'C' => 3, :g =>5, :G => 5, :T => 8, :t=>8} )
  end

  specify do
    expect(Bioinform::Support.various_key_types({'a' => 2, 'C' => 3, :g =>5, :T => 8})).to eq( {'a' => 2, :a => 2, 'C' => 3, :C => 3, :g =>5, 'g' => 5, :T => 8, 'T'=>8} )
  end

  specify do
    expect(Bioinform::Support.various_key_value_cases({:A => :T})).to eq( {:A => :T, :a => :t} )
  end

  specify do
    expect(Bioinform::Support.various_key_value_types({:A => :T})).to eq( {:A => :T, 'A' => 'T'} )
  end
end
