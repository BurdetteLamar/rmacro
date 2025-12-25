# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rmacro"
require 'stringio'
require "minitest/autorun"

class TestRmacro < Minitest::Test

  def streams(instring = '', outstring = '')
    instream = StringIO.new(String.new(instring), 'r+')
    outstream = StringIO.new(String.new(outstring), 'r+')
    yield instream, outstream
  end

  def do_test(instring, expected)
    streams(instring, expected) do |instream, outstream|
      m = RMacro.new(instream, outstream)
      m.expand
      assert_equal(expected, outstream.string)
    end
  end

  def do_tests(strings)
    strings.each_pair do |instring, expected|
      do_test(instring, expected)
    end
  end
  
end
