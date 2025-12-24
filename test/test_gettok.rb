require 'test_helper'

class TestRmacro < Minitest::Test

  def test_eof
    TestRmacro.streams do |instream, outstream|
      m = RMacro.new(instream, outstream)
      assert_nil(m.gettok)
    end
  end

  def test_too_long
    instring = 'x' * (1 + RMacro::TOKEN_MAX_SIZE)
    TestRmacro.streams(instring) do |instream, outstream|
      m = RMacro.new(instream, outstream)
      e = assert_raises(RuntimeError) { m.gettok }
      assert_match(/too long/, e.message)
    end
  end

  def test_length_ok
    instring = 'x' * RMacro::TOKEN_MAX_SIZE
    TestRmacro.streams(instring) do |instream, outstream|
      m = RMacro.new(instream, outstream)
      assert_equal(instring, m.gettok)
    end
  end

end
