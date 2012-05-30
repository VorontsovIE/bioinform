require 'test/unit'
require 'bioinform/support/same'

class TestEnumerableSame < Test::Unit::TestCase
  def test_same
    assert_equal(true, [1,3,9,7].same?(&:even?))
    assert_equal(true, [4,8,2,2].same?(&:even?))
    assert_equal(false, [1,8,3,2].same?(&:even?))
    
    assert_equal(true, %w{cat dog rat}.same?(&:length))
    assert_equal(false, %w{cat dog rabbit}.same?(&:length))
    
    assert_equal(true, %w{cat cat cat}.same?)
    assert_equal(false, %w{cat dog rat}.same?)
    
    assert_equal(true, [].same?(&:length))
    assert_equal(true, [].same?)
  end
end