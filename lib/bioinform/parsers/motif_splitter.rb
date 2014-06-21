module Bioinform
  class MotifSplitter
    attr_reader :start_motif_pattern, :spliiter
    def initialize(start_motif_pattern: /^\s*([^-+\s\d.]+|>.*)/, splitter: /^\s*$/)
      @start_motif_pattern = start_motif_pattern
      @splitter = splitter
    end

    def splitted_chunks(input)
      return input  unless @splitter
      input.each_line.chunk{|line| @splitter === line }.reject{|is_splitter, lines| is_splitter}.map{|is_splitter, lines| lines.join}
    end

    def split(input)
      splitted_chunks(input).map{|chunk|
        chunk.each_line.slice_before(@start_motif_pattern).map{|motif_lines| motif_lines.join }
      }.flatten.map(&:strip).reject(&:empty?)
    end
  end
end
