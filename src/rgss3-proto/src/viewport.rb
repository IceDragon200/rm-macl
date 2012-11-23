class Viewport

  include Disposable

  attr_accessor :ox, :oy, :z

  def initialize x=nil, y=nil, w=nil, h=nil
    if x.is_a?(Rect)
      @rect = x
    elsif [x,y,w,h].all?
      @rect = Rect.new x, y, w, h
    else  
      @rect = Rect.new 0, 0, Graphics.width, Graphics.height
    end  
    @ox, @oy = 0, 0
    @z = 0
    @disposed = false
  end

  def rect
    @rect
  end

  def update
  end

  def flash()
  end
    
end
