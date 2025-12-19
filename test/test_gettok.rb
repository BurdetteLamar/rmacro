require 'test_helper'

class TestRmacro < Minitest::Test

  def test_eof
    m = RMacro.new(StringIO.new(''))
    assert_nil(m.gettok)
  end

  def test_too_long
    s = 'x' * 200
    m = RMacro.new(StringIO.new(s))
    e = assert_raises(RuntimeError) { m.gettok }
    assert_match(/too long/, e.message)
  end

  def test_length_ok
    token = 'xyzzy'
    m = RMacro.new(StringIO.new(token + ' '))
    assert_equal(token, m.gettok)
  end

  def test_no_token
    m = RMacro.new(StringIO.new(' '))
    assert_nil(m.gettok)
  end

end
