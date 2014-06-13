require_relative '../alphabet'
module Bioinform
  class ConsensusFormatter

    # ConsensusFormatter.new{|pos, el, nucleotide_index| el == pos.max }
    def initialize(&block)
      raise Error, 'block is necessary to create an instance of ConsensusFormatter'  unless block_given?
      @block = block
    end

    # Simplest consensus formatter which takes into account only maximal elements
    def self.by_maximal_elements
      self.new{|pos, el, nucleotide_index| el == pos.max }
    end


    def format_string(pm)
      pm.each_position.map{|pos| iupac_letter_by_position(pos) }.join
    end

    def nucleotide_indices_by_position(pos)
      pos.each_index.select{|nucleotide_index|
        @block.call(pos, pos[nucleotide_index], nucleotide_index)
      }
    end

    def iupac_letter_by_position(pos)
      nucleotide_indices = nucleotide_indices_by_position(pos)
      Bioinform::IUPAC::IUPACLettersByNucleotideIndices[nucleotide_indices]
    end
    private :nucleotide_indices_by_position, :iupac_letter_by_position
  end
end
