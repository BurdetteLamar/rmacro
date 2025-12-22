# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rmacro"
require 'stringio'
require "minitest/autorun"

class TestRmacro < Minitest::Test

  def self.streams(instring = '', outstring = '')
    instream = StringIO.new(String.new(instring), 'r')
    outstream = StringIO.new(String.new(outstring), 'w')
    yield instream, outstream
  end

end
