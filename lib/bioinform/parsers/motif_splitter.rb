require 'bioinform/data_models/pm'

module Bioinform
  def self.split_onto_motifs(input)
    lines = input.lines.to_a
    mots = []
    while !lines.empty?
      fin = 0
      loop do
        begin
          fin += 1
          raise if fin > lines.length
          PM.new(lines[0,fin].join)
        rescue
          raise StopIteration
        end
      end
      mots << lines.shift(fin)
    end
    mots
  end
end
