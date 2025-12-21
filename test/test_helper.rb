# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rmacro"
require 'stringio'
require "minitest/autorun"

class TestRmacro < Minitest::Test

  def self.streams(instring = nil, outstring = nil)
    instream = StringIO.new(instring)
    outstream = StringIO.new(outstring)
    yield instream, outstream
  end

end
