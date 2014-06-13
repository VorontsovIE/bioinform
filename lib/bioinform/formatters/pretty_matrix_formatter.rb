require_relative 'raw_formatter'

module Bioinform
  class PrettyMatrixFormatter
    attr_reader :with_name, :letters_as_rows

    def initialize(options = {})
      @with_name = options.fetch(:with_name, true)
      @letters_as_rows = options.fetch(:letters_as_rows, false)
    end

    def header
      %w{A C G T}.map{|el| el.rjust(4).ljust(7)}.join + "\n"
    end

    def optional_name(motif)
      (@with_name && motif.name) ? (motif.name + "\n") : ''
    end

    def matrix_string(motif)
      matrix_rows = motif.each_position.map do |position|
        position.map{|el| el.round(3).to_s.rjust(6)}.join(' ')
      end

      matrix_str = matrix_rows.join("\n")
    end

    def format_string(motif)
      raise  Error, "PM doesn't respond to #name. Use formatter with option `with_name: false`"  if @with_name && !motif.respond_to?(:name)
      return RawFormatter.new(with_name: @with_name, letters_as_rows: @letters_as_rows).format_string(motif)  if @letters_as_rows
      optional_name(motif) + header + matrix_string(motif)
    end

    private :header, :optional_name, :matrix_string
  end
end
