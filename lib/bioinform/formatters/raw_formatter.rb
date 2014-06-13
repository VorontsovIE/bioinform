module Bioinform
  class RawFormatter
    attr_accessor :letters_as_rows, :with_name

    def initialize(options = {})
      @with_name = options.fetch(:with_name, true)
      @letters_as_rows = options.fetch(:letters_as_rows, false)
    end

    def header(motif)
      (@with_name && motif.name) ? (motif.name + "\n") : ''
    end

    def matrix_string(motif)
      if @letters_as_rows
        hsh = motif.to_hash
        [:A,:C,:G,:T].collect{|letter| "#{letter}|" + hsh[letter].join("\t")}.join("\n")
      else
        motif.each_position.map{|pos| pos.join("\t")}.join("\n")
      end
    end

    def format_string(motif)
      raise  Error, "PM doesn't respond to #name. Use formatter with option `with_name: false`"  if @with_name && !motif.respond_to?(:name)
      header = (@with_name && motif.name) ? (motif.name + "\n") : ''
      header + matrix_string(motif)
    end

    private :header, :matrix_string
  end
end
