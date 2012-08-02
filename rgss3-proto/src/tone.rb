class Tone

  attr_accessor :red, :green, :blue, :grey

  def initialize(r=0,g=0,b=0,a=255)
    @red, @green, @blue, @grey = 0,0,0,255
    _set(r,g,b,a)
  end

  def set(r=0,g=0,b=0,a=255)
    r,g,b,a = r.red,r.green,r.blue,r.grey if r.is_a?(Color)
    @red, @green, @blue, @grey = r||@red, g||@green, b||@blue, a||@grey
  end

  alias :_set :set

end