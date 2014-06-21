require_relative '../errors'

module Bioinform
  class MatrixParser
    # fix_nucleotides_number -- raises if matrix has not enough nucleotide columns
    attr_reader :has_name, :name_pattern, :has_header_row, :has_header_column, :nucleotides_in, :fix_nucleotides_number
    def initialize(options = {})
      @has_name = options.fetch(:has_name, nil)
      @name_pattern = options.fetch(:name_pattern, /^>?\s*(?<name>[^-+\d.\t\r\n][^\t\r\n]*).*$/)
      @has_header_row = options.fetch(:has_header_row, false)
      @has_header_column = options.fetch(:has_header_column, false)
      @nucleotides_in = options.fetch(:nucleotides_in, :columns)
      @fix_nucleotides_number = options.fetch(:fix_nucleotides_number, 4)

      raise Error, ':nucleotides_in option should be either :rows or :columns' unless  [:rows, :columns].include?(@nucleotides_in)
    end

    def parse!(input)
      lines = input.lines
      if @has_name == nil
        match = lines.first.match(@name_pattern)
        if match
          lines.shift
          name = match[:name]
        end
      elsif @has_name == false
        name = nil
      else
        match = lines.shift.match(@name_pattern)
        raise Error, "Name pattern doesn't match"  unless match
        name = match[:name]
      end
      lines.shift  if @has_header_row
      matrix = lines.map(&:rstrip).reject(&:empty?).map{|line| line.split }
      matrix = matrix.map{|row| row.drop(1) }  if @has_header_column
      matrix = matrix.map{|row| row.map{|el| Float(el) } }

      matrix = matrix.transpose  if @nucleotides_in == :rows
      # raise 'Matrix not valid' unless ! matrix.empty? && matrix.all?{|pos| pos.size == 4 }
      if @fix_nucleotides_number
        raise Error, 'Not enough nucleotides in a matrix'  unless matrix.all?{|pos| pos.size >= @fix_nucleotides_number}
        matrix = matrix.map{|pos| pos.first(@fix_nucleotides_number) }
      end
      {matrix: matrix, name: name}
    rescue => e
      raise Error, e.message
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
