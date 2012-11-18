class Plane

  include Disposable

  attr_accessor :bitmap
  attr_accessor :viewport
  attr_accessor :ox, :oy, :z

  def initialize(viewport=nil)
    @viewport    = viewport
    @ox, @oy, @z = 0, 0, 0
    @disposed    = false
    @bitmap      = nil
  end

  def _draw
    return if @disposed
  end

end