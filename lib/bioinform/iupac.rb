require_relative 'support'

module Bioinform
  module IUPAC
    NucleotideLettersByNucleotideIndex = [:A, :C, :G, :T]
    # NucleotideIndexByNucleotideLetter = Bioinform::Support.element_indices(NucleotideLettersByNucleotideIndex)
    IUPACLetterByIUPACIndex = [:A, :C, :G, :T, :M, :R, :W, :S, :Y, :K, :V, :H, :D, :B, :N]
    # IUPACIndexByIUPACLetter = Bioinform::Support.element_indices(IUPACLetterByIUPACIndex)

    NucleotideIndicesByIUPACLetter = {
      A: [0], C: [1], G: [2], T: [3],
      M: [0, 1], R: [0, 2], W: [0, 3], S: [1, 2], Y: [1, 3], K: [2, 3],
      V: [0, 1, 2], H: [0, 1, 3], D: [0, 2, 3], B: [1, 2, 3],
      N: [0, 1, 2, 3]
    }
    IUPACLettersByNucleotideIndices = Bioinform::Support.with_key_permutations(NucleotideIndicesByIUPACLetter.invert)

    def self.complement_iupac_letter(iupac_letter)
      # nucleotide_indices = NucleotideIndicesByIUPACLetter[iupac_letter]
      # complement_nucleotide_indices = nucleotide_indices.map{|nucleotide_index| 3 - nucleotide_index }
      # IUPACLettersByNucleotideIndices[complement_nucleotide_indices]
      require_relative 'alphabet'
      IUPACAlphabet.complement_letter(iupac_letter)
    end

    def self.complement_iupac_index(iupac_index)
      require_relative 'alphabet'
      IUPACAlphabet.complement_index(iupac_index)
      # letter = IUPACLetterByIUPACIndex[iupac_index]
      # complement_letter = complement_iupac_letter(letter)
      # IUPACIndexByIUPACLetter[complement_letter]
    end
  end
end
