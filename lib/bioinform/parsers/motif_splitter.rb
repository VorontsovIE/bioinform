module Bioinform
  #
  # MotifSpliiter is designed to split text into chunks with separate motifs.
  # It enumerates input line by line.
  # One can supply two options:
  #   * pattern for splitter `splitter_pattern`
  #   * `start_motif_pattern` which can determine start of motif but doesn't
  #     match within motif
  # If specified pattern is nil, corresponding splitting is not applied.
  # Paterns are applied by `#===` operator, thus both regexp or a Proc are
  # valid options. Proc accepts a line and should return true if line is
  # a splitter or is a motif start.
  #
  # Splitter method `#split` returns an array of strings. Each of returned
  # strings represents a motif. Motifs exclude splitter but include motif 
  # start, thus one can divide input both by lines which will be dismissed
  # and by lines which will be retained.
  #
  class MotifSplitter
    attr_reader :start_motif_pattern, :spliiter

    def initialize(start_motif_pattern: /^\s*([^-+\s\d.]+|>.*)/, splitter_pattern: /^\s*$/)
      @start_motif_pattern = start_motif_pattern
      @splitter_pattern = splitter_pattern
    end

    def parts_divided_by_splitter(input)
      return input  unless @splitter_pattern
      input.each_line.chunk{|line| @splitter_pattern === line }.reject{|is_splitter, lines| is_splitter}.map{|is_splitter, lines| lines.join}
    end

    def parts_divided_by_motif_starts(input)
      return input  unless @start_motif_pattern
      input.each_line.slice_before(@start_motif_pattern).map{|motif_lines| motif_lines.join }
    end

    private :parts_divided_by_splitter, :parts_divided_by_motif_starts

    def split(input)
      parts_divided_by_splitter(input).map{|chunk|
        parts_divided_by_motif_starts(chunk)
      }.flatten.map(&:strip).reject(&:empty?)
    end
  end
end
