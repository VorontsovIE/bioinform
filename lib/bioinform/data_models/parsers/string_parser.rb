require 'bioinform/support/multiline_squish'
require 'bioinform/data_models/pm'
require 'bioinform/data_models/parser'
require 'bioinform/data_models/parsers/array_parser'

class StringParser < PM::Parser    
  def number_pat
    '[+-]?\d+(\.\d+)?'
  end
  def row_pat 
    "(#{number_pat} )*#{number_pat}"
  end
  def name_pat
    '>? ?(?<name>[\w.+:-]+)'
  end
  def matrix_pat 
    "(?<matrix>(#{row_pat}\n)*#{row_pat})"
  end
  def header_pat
    "(#{name_pat}\n)?"
  end
  def pattern
    /\A#{header_pat}#{matrix_pat}\z/
  end
  
  def matrix_preprocess(matrix)
    matrix.split("\n").map{|line| line.split.map(&:to_f)}
  end
  
  # when matrix is extracted from the string it should be transformed to a matrix of numerics
  def parse
    super
    match = input.multiline_squish.match(pattern)
    matrix = matrix_preprocess( match[:matrix] )
    result = ArrayParser.new(matrix).parse
    match[:name]  ?  result.merge(name: match[:name])  :  result
  end
  
  def can_parse?
    case input
    when String      
      match = input.multiline_squish.match(pattern)
      return false  unless match
      matrix = matrix_preprocess( match[:matrix] )
      matrix && ArrayParser.new(matrix).can_parse?
    end
  rescue 
    false
  end
end