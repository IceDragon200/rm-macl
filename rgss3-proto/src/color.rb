class Color

  attr_accessor :red, :green, :blue, :alpha

  def initialize(r=0,g=0,b=0,a=255)
    @red, @green, @blue, @alpha = 0,0,0,255
    _set(r,g,b,a)
  end

  def set(r=0,g=0,b=0,a=255)
    r,g,b,a = r.red,r.green,r.blue,r.alpha if r.is_a?(Color)
    @red, @green, @blue, @alpha = r||@red, g||@green, b||@blue, a||@alpha
  end

  alias :_set :set

  def to_gosu
    Gosu::Color.rgba(red, green, blue, alpha)#(alpha + (blue << 4) + (green << 8) + (red << 12))
  end

end