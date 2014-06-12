require_relative 'iupac'

module Bioinform
  class ComplimentableAlphabet
    # Alphabet.new([:A,:C,:G,:T], [:T,:G,:C,:A])
    def initialize(alphabet, complements)
      @letter_by_index = alphabet
      @complement_letter_by_index = complements
      @index_by_letter = Support::element_indices(alphabet)
      raise Error, "Complement's complement should be original letter"  unless valid?
    end

    def valid?
      @letter_by_index.all?{|letter| complement_letter(complement_letter(letter)) == letter }
    end
    private :valid?

    def letter_by_index(index)
      @letter_by_index[index] || raise(Error, "Unknown letter-index #{index}")
    end

    def index_by_letter(letter)
      @index_by_letter[letter] || raise(Error, "Unknown letter #{letter}")
    end

    def complement_letter(letter)
      index = @index_by_letter[letter] || raise(Error, "Unknown letter #{letter}")
      @complement_letter_by_index[index]
    end

    def complement_index(index)
      letter = @complement_letter_by_index[index] || raise(Error, "Unknown letter-index #{index}")
      @index_by_letter[letter]
    end
  end

  NucleotideAlphabet = ComplimentableAlphabet.new([:A,:C,:G,:T],[:T,:G,:C,:A])

  complement_iupac_letter = ->(iupac_letter) do
    nucleotide_indices = Bioinform::IUPAC::NucleotideIndicesByIUPACLetter[iupac_letter]
    complement_nucleotide_indices = nucleotide_indices.map{|nucleotide_index| 3 - nucleotide_index }
    Bioinform::IUPAC::IUPACLettersByNucleotideIndices[complement_nucleotide_indices]
  end
  IUPACAlphabet = ComplimentableAlphabet.new( Bioinform::IUPAC::IUPACLetterByIUPACIndex,
                                              Bioinform::IUPAC::IUPACLetterByIUPACIndex.map{|letter| complement_iupac_letter.call(letter) } )
end
