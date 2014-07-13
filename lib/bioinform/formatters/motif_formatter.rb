module Bioinform
  class MotifFormatter
    attr_reader :with_name, :nucleotides_in, :precision, :with_nucleotide_header, :with_position_header

    def initialize(options = {})
      @with_name = options.fetch(:with_name, :auto)
      @nucleotides_in = options.fetch(:nucleotides_in, :columns).to_sym
      @precision = options.fetch(:precision, false)
      @with_nucleotide_header = options.fetch(:with_nucleotide_header, false)
      @with_position_header = options.fetch(:with_position_header, false)
      raise Error, "`with_name` can be either `true` or `false` or `:auto` but was `#{@with_name}`"  unless [true, false, :auto].include?(@with_name)
      raise Error, "`nucleotides_in` can be either `:rows` or `:columns` but was `#{@nucleotides_in}`"  unless [:rows, :columns].include?(@nucleotides_in)
    end

    def format_name(motif)
      case @with_name
      when true
        raise Error, "Motif doesn't respond to #name"  unless motif.respond_to?(:name)
        ">#{motif.name}\n"
      when false
        ""
      when :auto
        (motif.respond_to?(:name) && motif.name && !motif.name.strip.empty?) ? ">#{motif.name}\n" : ""
      end
    end

    def element_rounded(el)
      precision ? sprintf("%.#{precision}g", el) : el.to_s
    end

    def position_index_formatted(pos)
      sprintf('%02d', pos)
    end

    private :element_rounded, :position_index_formatted

    def format_matrix(motif)
      result = ""
      result << "\t"  if with_nucleotide_header && with_position_header

      case @nucleotides_in
      when :columns
        if with_nucleotide_header
          result << motif.alphabet.each_letter.to_a.join("\t") << "\n"
        end
        motif.each_position.with_index do |pos, pos_index|
          result << "\n"  if pos_index != 0
          result << "#{position_index_formatted(pos_index + 1)}\t"  if with_position_header
          result << pos.map{|el| element_rounded(el) }.join("\t")
        end
      when :rows
        if with_position_header
          result << (1..motif.length).map{|pos| position_index_formatted(pos) }.join("\t") << "\n"
        end
        motif.alphabet.each_letter.with_index do |letter, letter_index|
          result << "\n"  if letter_index != 0
          result << "#{letter}\t"  if with_nucleotide_header
          result << motif.matrix.transpose[letter_index].map{|el| element_rounded(el) }.join("\t")
        end
      end
      result
    end

    def format(motif)
      format_name(motif) + format_matrix(motif)
    end

  end
end
