require 'win32api'
require 'zlib'
require 'dl'
module Graphics
  class << self
    attr_reader :width, :height
    def frame_rate
      @frame_rate ||= 60
    end
    def frame_rate= n 
      @frame_rate = n.clamp(40,120).to_i
    end
    def frame_count
      @frame_count ||= 0
    end
    def frame_count= n
      @frame_count = n.max(0).to_i
    end
    def update
      self.frame_count += 1
      sleep 1.0 / self.frame_rate
    end
    def resize_screen(w=544,h=416)
      @width,@height=w,h
    end
  end
end
module Input
  class << self
    A, B, C, X, Y, Z, L, R = [0]*8
    CTRL, ALT, SHIFT = [0]*3
    def update
    end
    def trigger?(n)
    end
    def repeat?(n)
    end
    def press?(n)
    end
  end  
end
class Rect
  attr_accessor :x, :y, :width, :height
  def initialize(x=nil,y=nil,w=nil,h=nil)
    _set x,y,w,h
  end
  def set(x=nil,y=nil,w=nil,h=nil)
    if x.is_a?(Array)
      x,y,w,h = *x 
    elsif x.is_a?(Rect) 
      x,y,w,h = x.to_a
    end  
    @x, @y, @width, @height = x||0, y||0, w||0, h||0
  end
  alias :_set :set
end
class Viewport
  def initialize(x=nil,y=nil,w=nil,h=nil)
    if [x,y,w,h].all?
      @rect = Rect.new x, y, w, h
    else  
      @rect = Rect.new 0, 0, Graphics.width, Graphics.height
    end  
  end
  def rect
    @rect
  end
  attr_accessor :ox,:oy,:z
end
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
end
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
class Window
  attr_accessor :contents
  attr_accessor :ox,:oy,:z
  def initialize(x=nil,y=nil,w=nil,h=nil)
    @rect = Rect.new
    set(x,y,w,h)
  end
  def set(x=nil,y=nil,w=nil,h=nil)
    if [x,y,w,h].all?
      @rect.set x, y, w, h
    else  
      @rect.set 0, 0, Graphics.width, Graphics.height
    end  
  end
end
class Sprite
  attr_accessor :viewport
  attr_accessor :x,:y,:z,:ox,:oy
  attr_accessor :bitmap
  attr_reader :width, :height
  def initialize(viewport=nil)
    @viewport = viewport
    @x,@y,@z  = 0,0,0
    @ox,@oy   = 0,0
    @width,@height=0,0
  end
end
class Plane
  attr_accessor :bitmap
  attr_accessor :viewport
  attr_accessor :ox,:oy,:z
  def initialize(viewport=nil)
    @viewport = viewport
    @ox,@oy,@z=0,0,0
  end
end
class Bitmap
  attr_reader :width,:height
  def initialize(bw,h)
    w = bw if bw.is_a?(Numeric)
    @width, @height = w.to_i, h.to_i
  end
end
class Font
  attr_accessor :name, :size, :bold, :italic, :shadow, :outline, :out_color, :color
  def initialize
    @name = ['Arial']
    @size = 20
    @bold,@italic,@shadow,@outline=[false]*4
    @color = Color.new 255,255,255,255
    @out_color = Color.new 0,0,0,48 
  end
end
# //
module Main
  class << self
    def pre_update
    end
    def post_update
    end
    def update
      pre_update
      update_basic
      post_update
    end
    def update_basic
      Graphics.update
      Input.update
    end
  end
end 
module Kernel
  def rgss_main
    begin
      yield
      # // If Input F12 retry
    end
  end
  def _demo_block
    begin
      yield
      gets 
    rescue Exception => ex
      p ex
      puts ex.backtrace
      gets
    end
  end
end
