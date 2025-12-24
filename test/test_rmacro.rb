# frozen_string_literal: true

require "test_helper"

class TestRmacro < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::RMacro::VERSION
  end

  def test_new_with_good_arguments
    # StringIO for both.
    TestRmacro.streams do |instream, outstream|
      RMacro.new(instream, outstream)
      assert(true) # Nothing raised.
    end
    # File for both.
    Dir.mktmpdir do |dir|
      File.open('t.txt', File::RDWR) do |file|
        RMacro.new(file, file)
        assert(true) # Nothing raised.
      end
    end
  end

  def test_new_with_bad_instream
    TestRmacro.streams do |instream, outstream|
      e = assert_raises StandardError do
        RMacro.new('foo', outstream)
      end
      assert_match(/Input/, e.message)
      assert_match(/lacks methods/, e.message)
      instream.close
      e = assert_raises StandardError do
        instream.getc
      end
      assert_instance_of(IOError, e)
      assert_match(/not opened for reading/, e.message)
    end
  end

  def test_new_with_bad_outstream
    TestRmacro.streams do |instream, outstream|
      e = assert_raises ArgumentError do
        RMacro.new(instream, 'foo')
      end
      assert_match(/Output/, e.message)
      assert_match(/lacks methods/, e.message)
      outstream.close
      e = assert_raises StandardError do
        outstream.putc('x')
      end
      assert_instance_of(IOError, e)
      assert_match(/not opened for writing/, e.message)
    end
  end

  def test_no_tokens
    instring = ' '
    TestRmacro.streams(instring) do |instream, outstream|
      m = RMacro.new(instream, outstream)
      assert_nil(m.gettok)
    end
  end

  def test_token
    instring = ' foo bar baz '
    TestRmacro.streams(instring) do |instream, outstream|
      m = RMacro.new(instream, outstream)
      m.expand
      assert_equal(instream.string, outstream.string)
    end
  end


end
