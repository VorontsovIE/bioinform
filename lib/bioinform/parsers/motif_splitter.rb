module Bioinform
  class MotifSplitter
    def initialize
    end

    def split(input)
      input.each_line.slice_before(/\A\s*[^-+\s\d.]|\A\s+\z/).map{|motif_lines| motif_lines.join.strip }.reject(&:empty?)
    end
  end
end
