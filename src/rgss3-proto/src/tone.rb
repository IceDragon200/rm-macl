class Tone

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

  def initialize(r=0, g=0, b=0, gr=255)
    @red, @green, @blue, @grey = 0, 0, 0, 0
    _set(r,g,b,gr)
  end

  def set(r=0, g=0, b=0, gr=0)
    r, g, b, g = r.red, r.green, r.blue, r.grey if r.is_a?(Tone)
    @red, @green, @blue, @grey = r||@red, g||@green, b||@blue, gr||@grey
  end

  alias :_set :set

end
