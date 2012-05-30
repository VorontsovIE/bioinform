require 'test/unit'
require 'bioinform/support/ptap'

class TestEnumerablePmap < Test::Unit::TestCase
  def test_ptap
    assert_equal ['abc','def','ghi'], ['abc','','','def','ghi'].ptap('',&:delete)
    
    x = ['abc','','','def','ghi']
    assert_equal false, ['abc','def','ghi'].equal?(x.ptap('',&:delete))
    
    x = ['abc','','','def','ghi']
    assert_equal true, x.equal?(x.ptap('',&:delete))
    
    x = ['abc','','','def','ghi']
    assert_equal ['abc','','','def','ghi'], ['abc','','','def','ghi'].ptap(&:to_s)
  end
end