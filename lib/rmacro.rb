require_relative "rmacro/version"

class RMacro

  attr_accessor :instream, :outstream

  TOKEN_MAX_SIZE = 100
  REQUIRED_INPUT_METHODS = %i[getc ungetc pos eof]
  REQUIRED_OUTPUT_METHODS = %i[putc]

  def initialize(instream, outstream)
    RMacro.check_streams(instream, outstream)
    self.instream = instream
    self.outstream = outstream
  end

  def gettok
    token = ''
    (0..).each do |i|
      if instream.eof
        return token.empty? ? nil : token
      end
      c = instream.getc
      if c.match(/\w/)
        if i == TOKEN_MAX_SIZE
          message = "Token '#{token}' too long at position #{instream.pos}."
          raise RuntimeError.new(message)
        end
        token += c
      else
        instream.ungetc(c)
        return token.empty? ? nil : token
      end
    end
  end

  def self.check_streams(instream, outstream)
    missing_input_methods = REQUIRED_INPUT_METHODS - instream.methods
    unless missing_input_methods.empty?
      message = "Input stream #{instream.class} lacks methods: #{missing_input_methods.join(', ')}."
      raise ArgumentError, message
    end
    missing_output_methods = REQUIRED_OUTPUT_METHODS - outstream.methods
    unless missing_output_methods.empty?
      message = "Output stream #{outstream.class} lacks methods: #{missing_output_methods.join(', ')}"
      raise ArgumentError, message
    end
  end
end
