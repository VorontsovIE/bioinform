require_relative 'support'
require_relative 'errors'

module Bioinform
  # alphabets for DNA/RNA (which do have complements)
  class ComplementableAlphabet
    attr_reader :alphabet, :complement_alphabet

    # ComplementableAlphabet.new([:A,:C,:G,:T], [:T,:G,:C,:A])
    def initialize(alphabet, complements)
      @alphabet = alphabet.map{|letter| letter.upcase.to_sym }
      @complement_alphabet = complements.map{|letter| letter.upcase.to_sym }

      @complements_by_letters = Support.various_key_value_case_types( @alphabet.zip(@complement_alphabet).to_h )

      @index_by_letter = Support.various_key_case_types(Support.element_indices(@alphabet))
      raise Error, "Complement's complement should be original letter"  unless valid?
    end

    def valid?
      non_duplicated_letters = (@alphabet.size == @alphabet.uniq.size)
      compatible_sizes = (@alphabet.size == @complement_alphabet.size)
      invertable_complement = @alphabet.all?{|letter| complement_letter(complement_letter(letter)) == letter }
      non_duplicated_letters && compatible_sizes && invertable_complement
    end
    private :valid?

    def size
      @alphabet.size
    end

    def each_letter(&block)
      @alphabet.each(&block)
    end

    def each_letter_index(&block)
      @alphabet.each_index(&block)
    end

    def letter_by_index(index)
      @alphabet[index] || raise(Error, "Unknown letter-index #{index}")
    end

    def index_by_letter(letter)
      @index_by_letter[letter] || raise(Error, "Unknown letter #{letter}")
    end

    def complement_letter(letter)
      @complements_by_letters[letter] || raise(Error, "Unknown letter #{letter}")
    end

    def complement_index(index)
      letter = @complement_alphabet[index] || raise(Error, "Unknown letter-index #{index}")
      @index_by_letter[letter]
    end

    def ==(other)
      @alphabet == other.alphabet && @complement_alphabet == other.complement_alphabet
    end
  end


  module IUPAC
    NucleotideIndicesByIUPACLetter = {
      A: [0], C: [1], G: [2], T: [3],
      M: [0, 1], R: [0, 2], W: [0, 3], S: [1, 2], Y: [1, 3], K: [2, 3],
      V: [0, 1, 2], H: [0, 1, 3], D: [0, 2, 3], B: [1, 2, 3],
      N: [0, 1, 2, 3]
    }
    IUPACLettersByNucleotideIndices = Bioinform::Support.with_key_permutations(NucleotideIndicesByIUPACLetter.invert)

    def self.complement_iupac_letter(iupac_letter)
      nucleotide_indices = NucleotideIndicesByIUPACLetter[iupac_letter]
      complement_nucleotide_indices = nucleotide_indices.map{|nucleotide_index| 3 - nucleotide_index }
      IUPACLettersByNucleotideIndices[complement_nucleotide_indices]
    end
  end

  iupac_letters = [:A, :C, :G, :T, :M, :R, :W, :S, :Y, :K, :V, :H, :D, :B, :N]

  NucleotideAlphabet = ComplementableAlphabet.new([:A,:C,:G,:T], [:T,:G,:C,:A])
  IUPACAlphabet = ComplementableAlphabet.new( iupac_letters,
                                              iupac_letters.map{|letter| IUPAC.complement_iupac_letter(letter) } )
end
