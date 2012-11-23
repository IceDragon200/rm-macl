class Tone

  def initialize(r=0, g=0, b=0, gr=255)
    @red, @green, @blue, @grey = 0, 0, 0, 0
    _set(r,g,b,gr)
  end

  attr_reader :red, :green, :blue, :alpha

  def red= n
    @red = n < -255 ? -255 : n > 255 ? 255 : n
  end

  def green= n
    @green = n < -255 ? -255 : n > 255 ? 255 : n
  end

  def blue= n
    @blue = n < -255 ? -255 : n > 255 ? 255 : n
  end

  def alpha= n
    @alpha = n < -255 ? -255 : n > 255 ? 255 : n
  end

  def set(*ints)
    case ints.size
    when 1 # Tone
      r = ints[0]
      r, g, b, a = r.red, r.green, r.blue, r.grey
    when 3 # RGB
      r, g, b = *ints
      a = @grey || 255
    when 4 # RGBA  
      r, g, b, a = *ints
    end  
    self.red, self.green, self.blue, self.grey = r, g, b, a
  end

  alias :_set :set

  def _dump(d = 0)
    [@red, @green, @blue, @alpha].pack('d4')
  end
   
  def self._load(s)
    Tone.new(*s.unpack('d4'))
  end

end
