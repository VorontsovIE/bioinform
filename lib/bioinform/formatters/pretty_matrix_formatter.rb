require_relative 'raw_formatter'

module Bioinform
  class PrettyMatrixFormatter
    attr_reader :with_name, :letters_as_rows
    def initialize(options = {})
      @with_name = options.fetch(:with_name, true)
      @letters_as_rows = options.fetch(:letters_as_rows, false)
    end

    def format_string(pm)
      raise  Error, "PM doesn't respond to #name. Use formatter with option `with_name: false`"  if @with_name && !pm.respond_to?(:name)

      return RawFormatter.new(pm, {with_name: @with_name, letters_as_rows: @letters_as_rows}).to_s  if @letters_as_rows

      header = %w{A C G T}.map{|el| el.rjust(4).ljust(7)}.join + "\n"
      matrix_rows = pm.each_position.map do |position|
        position.map{|el| el.round(3).to_s.rjust(6)}.join(' ')
      end

      matrix_str = matrix_rows.join("\n")

      if @with_name && pm.name
        pm.name + "\n" + header + matrix_str
      else
        header + matrix_str
      end
    end
  end
end
