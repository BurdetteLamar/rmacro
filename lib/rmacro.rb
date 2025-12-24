require_relative "rmacro/version"

class RMacro

  attr_accessor :instream, :outstream, :macro

  TOKEN_MAX_SIZE = 100
  REQUIRED_INPUT_METHODS = %i[getc ungetc pos eof]
  REQUIRED_OUTPUT_METHODS = %i[putc]


  def initialize(instream, outstream)
    RMacro.check_streams(instream, outstream)
    self.instream = instream
    self.outstream = outstream
    self.macro = {}
  end

  def define(name, expansion)
    macro[name] = expansion
  end

  def undefine(name)
    macro.delete(name)
  end

  def expand
    until instream.eof?
      tok = gettok
      outstream.write(tok)
    end
  end

  def gettok
    token = ''
    while true do
      if instream.eof
        return token.empty? ? nil : token
      end
      c = instream.getc
      unless c.match(/\w/)
        if token.empty?
          outstream.putc(c)
          next
        else
          instream.ungetc(c)
          return token.empty? ? nil : token
        end
      end
      if token.empty?
        if c.match(/0-9/)
          # Digit cannot begin a token.
          outstream.putc(c)
        else
          # Start a new token.
          token += c
        end
      else
        # Continue token.
        token += c
      end
      if token.size > TOKEN_MAX_SIZE
        message = "Token '#{token}' too long (#{token.size}) at position #{instream.pos}."
        raise RuntimeError.new(message)
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
