=begin
require 'bioinform/data_models/pm'

module Bioinform
# such a way stucks when first line is a name :-(

  def self.split_onto_motifs(input)
    input.split(/\n\s*\w*\s*\n/)
  end
end
=end