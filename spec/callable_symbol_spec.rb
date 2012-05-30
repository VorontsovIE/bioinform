require 'test/unit'
require 'bioinform/support/callable_symbol'

class TestEnumerablePmap < Test::Unit::TestCase
  def test_with_tap
    assert_equal ['abc','def','ghi'], ['abc','','','def','ghi'].tap(&:delete.(''))
    
    x = ['abc','','','def','ghi']
    assert_equal false, ['abc','def','ghi'].equal?(x.tap(&:delete.('')))
    
    x = ['abc','','','def','ghi']
    assert_equal true, x.equal?(x.tap(&:delete.('')))
    
    x = ['abc','','','def','ghi']
    assert_equal ['abc','','','def','ghi'], ['abc','','','def','ghi'].tap(&:to_s)
  end
  
  def test_pmap_bang_without_parameters
    x = [1,2,3]
    assert_equal x.map!(&:to_s), ['1', '2', '3']
    assert_equal x, ['1', '2', '3']
  end
  def test_with_map_bang_with_parameters
    y = [1,2,3]
    assert_equal y.map!(&:to_s.(2)), ['1', '10', '11']
    assert_equal y, ['1', '10', '11']
  end
  def test_with_map_without_bang
    x = [1,2,3]
    assert_equal x.map(&:to_s.(2)), ['1', '10', '11']
    assert_equal x, [1, 2, 3]
  end
  def test_one_more_with_map
    assert_equal [[1,2,3],[4,5,6]].map(&:join.(' ')).join("\n"), "1 2 3\n4 5 6"
    assert_equal [1,2,3,4,5].map(&:to_s.(2)), ['1', '10', '11', '100', '101']
  end
end