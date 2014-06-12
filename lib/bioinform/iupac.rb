module Bioinform
  module IUPAC
    # element_indices([:A,:C,:G,:T])  ==>  {:A=>0, :C=>1, :G=>2, :T=>3}
    def self.element_indices(arr)
      arr.each_with_index.inject({}) {|hsh, (letter, index)| hsh.merge(letter => index) }
    end

    # hash_keys_permuted([0,1], :A)  ==>  {[0,1] => :A, [1,0] => :A}
    def self.hash_keys_permuted(key, value)
      key.permutation.inject({}){|hsh, perm| hsh.merge(perm => value) }
    end

    # with_key_permutations({[0,1] => :A, [0,2] => :T})  ==>  {[0,1] => :A, [1,0] => :A, [0,2] => :T, [2,0]=>:T}
    def self.with_key_permutations(hash)
      hash.inject({}) {|h, (indices, letter)| h.merge( hash_keys_permuted(indices, letter) ) }
    end

    NucleotideLettersByNucleotideIndex = [:A, :C, :G, :T]
    NucleotideIndexByNucleotideLetter = element_indices(NucleotideLettersByNucleotideIndex)
    IUPACLetterByIUPACIndex = [:A, :C, :G, :T, :M, :R, :W, :S, :Y, :K, :V, :H, :D, :B, :N]
    IUPACIndexByIUPACLetter = element_indices(IUPACLetterByIUPACIndex)

    NucleotideIndicesByIUPACLetter = {
      A: [0], C: [1], G: [2], T: [3],
      M: [0, 1], R: [0, 2], W: [0, 3], S: [1, 2], Y: [1, 3], K: [2, 3],
      V: [0, 1, 2], H: [0, 1, 3], D: [0, 2, 3], B: [1, 2, 3],
      N: [0, 1, 2, 3]
    }
    IUPACLettersByNucleotideIndices = with_key_permutations(NucleotideIndicesByIUPACLetter.invert)

    def self.complement_iupac_letter(iupac_letter)
      nucleotide_indices = NucleotideIndicesByIUPACLetter[iupac_letter]
      complement_nucleotide_indices = nucleotide_indices.map{|nucleotide_index| 3 - nucleotide_index }
      IUPACLettersByNucleotideIndices[complement_nucleotide_indices]
    end

    def self.complement_iupac_index(iupac_index)
      letter = IUPACLetterByIUPACIndex[iupac_index]
      complement_letter = complement_iupac_letter(letter)
      IUPACIndexByIUPACLetter[complement_letter]
    end
  end
end
