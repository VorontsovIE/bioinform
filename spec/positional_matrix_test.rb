#require 'spec_helper'
require 'test/unit'
require 'bioinform/data_models/positional_matrix'

class PositionalMatrixTest < Test::Unit::TestCase
  def test_input_has_name
    m = PositionalMatrix.new <<-EOF
      > Testmatrix_1
      1.23 4.56 1.2  1.0
      1.45 1.23 1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6  8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.matrix, [[1.23, 4.56, 1.2,  1.0], [1.45, 1.23, 1.48, 1.9], [-5.6, 7, 4.56, 10.1], [4.13, -15.6, 8.7, 0.0],[2.2, 3.3, 4.4, 5.5]]
    assert_equal m.name, 'Testmatrix_1'
  end
  
  def test_input_has_tabs_and_multiple_spaces_and_carriage_returns_at_eol
    m = PositionalMatrix.new <<-EOF
      1.23\t4.56 1.2  1.0\r
      1.45 1.23   1.48 1.9\r
      -5.6 7.8  4.56 10.1
      4.13 -15.6\t\t8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.matrix, [[1.23, 4.56, 1.2,  1.0], [1.45, 1.23, 1.48, 1.9], [-5.6, 7.8, 4.56, 10.1], [4.13, -15.6, 8.7, 0.0],[2.2, 3.3, 4.4, 5.5]]
  end

  def test_input_has_finishing_and_leading_newlines
    m = PositionalMatrix.new <<-EOF
      
      > Testmatrix_1
      1.23 4.56 1.2  1.0
      1.45 1.23 1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6  8.7 0.0
      2.2 3.3 4.4 5.5
      
    EOF
    assert_equal m.matrix, [[1.23, 4.56, 1.2,  1.0], [1.45, 1.23, 1.48, 1.9], [-5.6, 7.0, 4.56, 10.1], [4.13, -15.6, 8.7, 0.0],[2.2, 3.3, 4.4, 5.5]]
  end
  
  def test_input_has_no_name
    m = PositionalMatrix.new <<-EOF
      1.23 4.56 1.2  1.0
      1.45 1.23 1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6  8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.matrix, [[1.23, 4.56, 1.2,  1.0], [1.45, 1.23, 1.48, 1.9], [-5.6, 7.0, 4.56, 10.1], [4.13, -15.6, 8.7, 0.0],[2.2, 3.3, 4.4, 5.5]]
    assert_equal m.name, nil
  end
  
  def test_input_positions_as_rows
  m = PositionalMatrix.new <<-EOF
      Testmatrix-2
      1.23 4.56 1.2  1.0 78 12.3
      1.45 1.23 1.48 1.9 10.1 12.0
      -5.6 7  4.56 10.1 4 12
      4.13 -15.6  8.7 0.0 1.1 5
    EOF
    assert_equal m.matrix, [[1.23, 1.45, -5.6,  4.13], [4.56, 1.23, 7.0, -15.6], [1.2, 1.48, 4.56, 8.7], [1.0, 1.9, 10.1, 0.0],[78, 10.1, 4.0, 1.1], [12.3, 12.0, 12.0, 5.0]]
    assert_equal m.name, 'Testmatrix-2'
  end
  
  def test_fails_on_nonnumeric_data
    assert_raise ArgumentError do
      m = PositionalMatrix.new <<-EOF
        1.23ss 4.56ww 1.2  1.0
        1.45zz 1.23 1.48 1.9
        -5.6 7  4.56 10.1
        4.13 -15.6  8.7 0.0
        2.2 3.3 4.4 5.5
      EOF
    end
  end
  
  def test_fails_on_different_row_size
    assert_raise ArgumentError do
      m = PositionalMatrix.new <<-EOF
        > Testmatrix_1
        1.23 4.56 1.2  1.0
        1.45 1.23 1.48
        -5.6 7  4.56 10.1
        4.13 -15.6  8.7 0.0
        2.2 3.3 4.4 5.5
      EOF
    end
  end
  
  def test_fails_if_either_row_nor_col_has_size_4
    assert_raise ArgumentError do
    m = PositionalMatrix.new <<-EOF
      1 2 3 4 5 
      2 2 -2 2 2
      3 3 3 3 3
      4 -4 4 -4 -4 
      5 5 -5 -5 5
    EOF
    end
  end  
  
  def test_to_s
    m = PositionalMatrix.new <<-EOF
      > Testmatrix_1
      1.23 4.56  1.2  1.0
      1.45 1.23  1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6   8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.to_s, "Testmatrix_1\n1.23\t4.56\t1.2\t1.0\n1.45\t1.23\t1.48\t1.9\n-5.6\t7.0\t4.56\t10.1\n4.13\t-15.6\t8.7\t0.0\n2.2\t3.3\t4.4\t5.5"
    assert_equal m.to_s(false), "1.23\t4.56\t1.2\t1.0\n1.45\t1.23\t1.48\t1.9\n-5.6\t7.0\t4.56\t10.1\n4.13\t-15.6\t8.7\t0.0\n2.2\t3.3\t4.4\t5.5"
  end
  
  def test_pretty_string
    m = PositionalMatrix.new <<-EOF
      > Testmatrix_1
      1.23 4.56  1.2  1.0
      1.45 1.23  1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6   8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.pretty_string, "Testmatrix_1\n   A      C      G      T   \n  1.23   4.56    1.2    1.0\n  1.45   1.23   1.48    1.9\n  -5.6    7.0   4.56   10.1\n  4.13  -15.6    8.7    0.0\n   2.2    3.3    4.4    5.5"
    assert_equal m.pretty_string(false), "   A      C      G      T   \n  1.23   4.56    1.2    1.0\n  1.45   1.23   1.48    1.9\n  -5.6    7.0   4.56   10.1\n  4.13  -15.6    8.7    0.0\n   2.2    3.3    4.4    5.5"
  end
  
  def test_to_hash
    m = PositionalMatrix.new <<-EOF
      > Testmatrix_1
      1.23 4.56  1.2  1.0
      1.45 1.23  1.48 1.9
      -5.6 7  4.56 10.1
      4.13 -15.6   8.7 0.0
      2.2 3.3 4.4 5.5
    EOF
    assert_equal m.to_hash, {A: [1.23, 1.45, -5.6, 4.13, 2.2], C:[4.56, 1.23, 7.0, -15.6, 3.3], G:[1.2, 1.48, 4.56, 8.7, 4.4], T:[1.0, 1.9, 10.1, 0.0, 5.5]}.with_indifferent_access
  end
  
  def test_hash_input
    m = PositionalMatrix.new(A: [1.23, 1.45, -5.6, 4.13, 2.2], C:[4.56, 1.23, 7, -15.6, 3.3],'G' => [1.2, 1.48, 4.56, 8.7, 4.4], 'T'=>[1.0, 1.9, 10.1, 0.0, 5.5])
    assert_equal m.matrix, [[1.23, 4.56, 1.2,  1.0], [1.45, 1.23, 1.48, 1.9], [-5.6, 7.0, 4.56, 10.1], [4.13, -15.6, 8.7, 0.0],[2.2, 3.3, 4.4, 5.5]]
  end
  
  def test_size
    m = PositionalMatrix.new(A: [1.23, 1.45, -5.6, 4.13, 2.2], C:[4.56, 1.23, 7, -15.6, 3.3],'G' => [1.2, 1.48, 4.56, 8.7, 4.4], 'T'=>[1.0, 1.9, 10.1, 0.0, 5.5])
    assert_equal m.size, 5
    assert_equal m.length, m.size
  end
  
  def test_fantom_parser
    input = <<-EOS
      NA  motif_CTNCAG					
      P0	A	C	G	T	
      P1	0	1878368	0	0	
      P2	0	0	0	1878368	
      P3	469592	469592	469592	469592	
      P4	0	1878368	0	0	
      P5	1878368	0	0	0	
      P6	0	0	1878368	0	
    EOS
    m = PositionalMatrix.new input, PositionalMatrix::FantomParser
    assert_equal 'motif_CTNCAG', m.name
    assert_equal [[0,1878368,0,0],[0,0,0,1878368],[469592,469592,469592,469592],[0,1878368,0,0],[1878368,0,0,0],[0,0,1878368,0]], m.matrix
  end
  
end