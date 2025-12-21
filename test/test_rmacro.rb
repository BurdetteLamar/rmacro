# frozen_string_literal: true

require "test_helper"

class TestRmacro < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::RMacro::VERSION
  end

  def test_new_with_good_arguments
    TestRmacro.streams do |instream, outstream|
      RMacro.new(instream, outstream)
      assert(true) # Nothing raised.
    end
  end

  def test_new_with_bad_instream
    TestRmacro.streams do |_, outstream|
      e = assert_raises ArgumentError do
        RMacro.new('foo', outstream)
      end
      assert_match(/Input/, e.message)
      assert_match(/lacks methods/, e.message)
    end
  end

  def test_new_with_bad_outstream
    TestRmacro.streams do |instream, _|
      e = assert_raises ArgumentError do
        RMacro.new(instream, 'foo')
      end
      assert_match(/Output/, e.message)
      assert_match(/lacks methods/, e.message)
    end
  end

end
