# frozen_string_literal: true

require "test_helper"

class TestRmacro < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RMacro::VERSION
  end

  def test_new_with_good_argument
    strio = StringIO.new('')
    RMacro.new(strio)
    assert(true) # Nothing raised.
  end

  def test_new_with_bad_argument
    e = assert_raises ArgumentError do
      RMacro.new('foo')
    end
    assert_match(/lacks methods/, e.message)
  end

end
