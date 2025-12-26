require_relative "rmacro/version"

class RMacro

  attr_accessor :instream, :outstream, :macros

  TOKEN_MAX_SIZE = 100
  REQUIRED_INPUT_METHODS = %i[getc ungetc pos eof]
  REQUIRED_OUTPUT_METHODS = %i[putc]


  def initialize(instream, outstream)
    self.instream = instream
    self.outstream = outstream
    check_streams
    self.macros = initialized_macros
  end

  def expand
    until instream.eof?
      tok = gettok
      value = macros[tok]
      if value.nil?
        outstream.write(tok)
      else
        value = value.first
        case value
        when String
          outstream.write(value)
        when Proc
          value.call
        else
        end
      end
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

  def check_streams
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

  def dnl
    until instream.getc == "\n"
      return if instream.eof
    end
  end

  def initialized_macros
    {
      'dnl' => [proc { dnl }]
    }
  end

end
