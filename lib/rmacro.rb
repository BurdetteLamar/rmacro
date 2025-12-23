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
      token = gettok
    end
  end

  def gettok
    token = ''
    while true do
      if instream.eof
        return token.empty? ? nil : token
      end
      c = instream.getc
      case token.size
      when 0 # Only '.' can begin a token.
        if c == '.'
          token += c
        else
          outstream.putc(c)
        end
      when 1 # Only a letter can be the second character of a token.
        if c.match(/[a-zA-Z]/)
          token += c
        else
          outstream.write(token)
          outstream.putc(c)
          token = ''
        end
      else # Only a word character can continue the token.
        if c.match(/\w/)
          token += c
        else
          instream.ungetc(c)
          return token
        end
      end
      if token.size > TOKEN_MAX_SIZE
        message = "Token '#{token}' too long (#{token.size}) at position #{instream.pos}."
        raise RuntimeError.new(message)
      end

      # unless c.match(/\w/)
      #   if token.empty?
      #     outstream.putc(c)
      #   else
      #     instream.ungetc(c)
      #     return token.empty? ? nil : token
      #   end
      # else
      #   token += c
      #   if token.size > TOKEN_MAX_SIZE
      #     message = "Token '#{token}' too long (#{token.size}) at position #{instream.pos}."
      #     raise RuntimeError.new(message)
      #   end
      # end
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
