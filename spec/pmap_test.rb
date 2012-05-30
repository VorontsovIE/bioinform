require 'test/unit'
require 'bioinform/support/pmap'

class TestEnumerablePmap < Test::Unit::TestCase
  def test_pmap_bang_without_parameters
    x = [1,2,3]
    assert_equal x.pmap!(&:to_s), ['1', '2', '3']
    assert_equal x, ['1', '2', '3']
  end
  def test_pmap_bang_with_parameters
    y = [1,2,3]
    assert_equal y.pmap!(2, &:to_s), ['1', '10', '11']
    assert_equal y, ['1', '10', '11']
  end
  def test_pmap_without_bang
    x = [1,2,3]
    assert_equal x.pmap(2, &:to_s), ['1', '10', '11']
    assert_equal x, [1, 2, 3]
  end
  def test_one_more_pmap
    assert_equal [[1,2,3],[4,5,6]].pmap(' ',&:join).join("\n"), "1 2 3\n4 5 6"
    assert_equal [1,2,3,4,5].pmap(2,&:to_s), ['1', '10', '11', '100', '101']
  end
end