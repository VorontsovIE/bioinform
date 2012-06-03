#require 'spec_helper'
require 'test/unit'
require 'bioinform/data_models/positional_matrix'

class PositionalMatrixTest < Test::Unit::TestCase
  
  def test_fantom_parser
    
    m = PositionalMatrix.new input, PositionalMatrix::FantomParser
    assert_equal 'motif_CTNCAG', m.name
    assert_equal [[0,1878368,0,0],[0,0,0,1878368],[469592,469592,469592,469592],[0,1878368,0,0],[1878368,0,0,0],[0,0,1878368,0]], m.matrix
  end
  
end