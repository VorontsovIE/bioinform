module Bioinform
  class TransfacFormatter
    attr_accessor :with_name

    def initialize(options = {})
      @with_name = options.fetch(:with_name, true)
    end

    def header(motif)
      if @with_name && motif.name
        "ID #{motif.name}\nBF StubSpeciesName\nP0\tA\tC\tG\tT\n"
      else
        raise 'Transfac should have the name field'
      end
    end

    def matrix_string(motif)
      motif.each_position.map.with_index{|pos,ind|
        line_number = ind.to_s
        line_number = (line_number.size == 1) ? "0#{line_number}" : line_number
        line_number + ' ' + pos.join("\t")
      }.join("\n")
    end

    def format(motif)
      header(motif) + matrix_string(motif) + "\nXX\n//"
    end

    private :header, :matrix_string
  end
end
