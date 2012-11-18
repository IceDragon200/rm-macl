class Sprite

  include Disposable

  attr_accessor :viewport
  attr_accessor :x, :y, :z, :ox, :oy
  attr_accessor :bitmap
  attr_reader :width, :height
  attr_accessor :src_rect

  attr_accessor :opacity
  attr_accessor :bush_opacity
  attr_accessor :bush_depth
  attr_accessor :angle

  def initialize(viewport=nil)
    @viewport       = viewport
    @x, @y, @z      = 0, 0, 0
    @ox, @oy        = 0, 0
    @width, @height = 0, 0
    @src_rect       = Rect.new 0, 0, 0, 0
    @opacity        = 255
    @bush_opacity   = 255
    @bush_depth     = 0
    @disposed       = false
  end

  def _draw
    return if @disposed
    return unless @bitmap
    return if src_rect.empty?
    ax, ay, az = 0, 0, 0
    ax, ay, az = viewport.rect.x, viewport.rect.y, viewport.z * 100 if viewport
    Main.window.translate(ax, ay) do 
      Main.window.clip_to(x - ox, y - oy, src_rect.width, src_rect.height) do 
        @bitmap.data.draw(x - src_rect.x - ox, y - src_rect.y - oy, z + az)
      end
    end
  end

  def update
  end

end