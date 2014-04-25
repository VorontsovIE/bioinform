module Bioinform  
  class MatrixParser
    def initialize(options = {})
      @has_name = options.fetch(:has_name, true)
      @name_pattern = options.fetch(:name_pattern, /^>?\s*(?<name>[^\t\r\n]+).*$/)
      @has_header_row = options.fetch(:has_header_row, false)
      @has_header_column = options.fetch(:has_header_column, false)
      @nucleotides_in = options.fetch(:nucleotides_in, :columns)

      raise ':nucleotides_in option should be either :rows or :columns' unless  [:rows, :columns].include?(@nucleotides_in)
    end

    def parse!(input)
      lines = input.lines
      if @has_name
        match = lines.shift.match(@name_pattern)
        raise 'Name pattern doesn\'t match'  unless match
        name = match[:name]
      end
      lines.shift  if @has_header_row
      matrix = lines.map(&:strip).reject(&:empty?).map{|line| line.split }
      matrix = matrix.map{|row| row.drop(1) }  if @has_header_column
      matrix = matrix.map{|row| row.map{|el| Float(el) } }

      matrix = matrix.transpose  if @nucleotides_in == :rows
      # raise 'Matrix not valid' unless ! matrix.empty? && matrix.all?{|pos| pos.size == 4 }
      {matrix: matrix, name: name}
    end

    def parse(input)
      parse!(input) rescue nil
    end

    def valid?(input)
      result = parse!(input)
    rescue
      false
    end
  end
end
