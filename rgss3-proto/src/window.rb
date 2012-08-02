class Window

  include Disposable

  attr_accessor :contents
  attr_accessor :ox, :oy, :z

  def initialize(x=nil,y=nil,w=nil,h=nil)
    @rect = Rect.new
    set(x,y,w,h)
    @disposed = false
  end

  def set(x=nil,y=nil,w=nil,h=nil)
    if [x,y,w,h].all?
      @rect.set x, y, w, h
    else  
      @rect.set 0, 0, Graphics.width, Graphics.height
    end  
  end

end