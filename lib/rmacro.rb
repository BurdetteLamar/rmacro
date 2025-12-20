require_relative "rmacro/version"

class RMacro

  attr_accessor :instream

  TOKEN_MAX_SIZE = 100
  REQUIRED_METHODS = %i[getc ungetc pos eof]

  def initialize(instream)
    missing_methods = REQUIRED_METHODS - instream.methods
    unless missing_methods.empty?
      message = "Input stream #{instream.class} lacks methods: #{missing_methods.join(', ')}"
      raise ArgumentError, message
    end
    self.instream = instream
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
          message = "Token '#{token}' too long at position #{instream.pos}"
          raise RuntimeError.new(message)
        end
        token += c
      else
        instream.ungetc(c)
        return token.empty? ? nil : token
      end
    end
  end

end
