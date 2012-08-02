#-apndmacro _imported_
#-inject gen_scr_imported 'Surface', '0x11000'
#-end:
#-inject gen_module_header 'Mixin::Surface'
module MACL::Mixin::Surface
  SYM_ARGS = [:x,:y,:width,:height]
  class SurfaceError < StandardError
  end
  include MACL::Constants  
  extend MACL::Mixin::Archijust
  def rwidth
    self.width
  end
  def rheight
    self.height
  end  
  def vx 
    self.x
  end  
  def vy 
    self.y
  end  
  def vx= n
    self.x = n
  end
  def vy= n
    self.y = n
  end  
  def vx2 
    self.vx + self.rwidth
  end  
  def vy2 
    self.vy + self.rheight
  end  
  def vx2= n
    self.x = n - self.rwidth
  end  
  def vy2= n
    self.y = n - self.rheight
  end 
  def cx
    x + width / 2
  end
  def cy
    y + height / 2
  end
  def cx= x
    self.x = x - self.width / 2.0
  end
  def cy= y
    self.y = y - self.height / 2.0
  end
  def vset x=nil,y=nil,x2=nil,y2=nil
    self.vx = x  || self.vx
    self.vy = y  || self.vy
    self.vx2= x2 || self.vx2
    self.vy2= y2 || self.vy2
    self
  end 
  def xset x=nil,y=nil,w=nil,h=nil
    x,y,w,h = x.get_values(:x,:y,:width,:height) if(x.is_a?(Hash))
    self.x,self.y,self.width,self.height = x||self.x,y||self.y,w||self.width,h||self.height
    self
  end   
  def mid_x n=0
    self.x + (self.width-n) / 2
  end
  def mid_y n=0
    self.y + (self.height-n) / 2
  end
  def area
    rwidth * rheight
  end  
  def perimeter
    (rwidth * 2) + (rheight * 2)
  end 
  define_as space_rect: Rect.new(0,0,0,0)
  def clamp_to_space 
    v4 = (viewport || Graphics).rect.to_v4
    r = space_rect
    cx = v4.x + r.x
    cw = v4.vx2 - self.rwidth - r.rwidth
    cy = v4.y + r.y
    ch = v4.vy2 - self.rheight - r.rheight
    self.x, self.y = self.x.clamp(cx,cw), self.y.clamp(cy,ch)
  end 
  # . x . Only works with Padded stuff
  #def _surface_padding 
  #  (respond_to?(:padding) ? padding : 0)
  #end  
  def _surface_padding 
    standard_padding
  end  
  def adjust_rect_to_contents rect,pad=_surface_padding
    return rect.contract(pad)
  end
  def adjust_rect_to_window rect,pad=_surface_padding
    return rect.expand(pad)
  end   
  # O_O
  def calc_pressure n,anchor,invert=false
    if anchor == ANCHOR[:horz]
      return 0 if n < self.x || n > self.vx2
      n = n - self.x
      n2 = (self.vx2 - self.x)
      n = n2 - n if invert
      n = n / n2.to_f
    elsif anchor == ANCHOR[:vert]
      return 0 if n < self.y || n > self.vy2
      n = n - self.y
      n2 = (self.vy2 - self.y)
      n = n2 - n if invert
      n = n / n2.to_f
    end  
    return n
  end
  def center child_rect
    Surface.center self, child_rect
  end
  def to_a
    return self.vx, self.vy, self.rwidth, self.rheight
  end
  def to_v4a 
    return self.vx, self.vy, self.vx2, self.vy2
  end
  def to_v4
    Vector4.new *to_v4a
  end
  def to_rect
    Rect.new *to_a
  end
  def xto_a *args,&block
    (args&SYM_ARGS).collect(&(block_given? ? block : proc{|sym|self.send(sym)}))
  end
  def xto_h *args
    Hash[xto_a(*args){|sym|[sym,self.send(sym)]}]
  end
  def in_area? ax, ay
    return ax.between?(self.vx, self.vx2) && 
      ay.between?(self.vy, self.vy2)
  end 
  def intersect? v4  
    return in_area?(v4.x, v4.y) || in_area?(v4.width,v4.height)
  end  ##
  # // Destructive
  define_exfunc 'contract' do |n=0,anchor=5|
    a = [0,0,0,0]
    a = case anchor
    when -1 # // Do nothing!?
      [0,0,0,0]
    when ANCHOR[:horz0]  
      [0,0,-n,0] 
    when ANCHOR[:horz], ANCHOR[:horz1]
      [n,0,-n*2,0] 
    when ANCHOR[:horz2]    
      [n,0,n,0] 
    when ANCHOR[:vert1]        
      [0,-n,0,0] 
    when ANCHOR[:vert], ANCHOR[:vert1]
      [0,n,0,-n*2] 
    when ANCHOR[:vert2]      
      [0,n,0,n] 
    # // NUMPAD
    when ANCHOR[:center]
      [n,n,-n*2,-n*2] 
    when ANCHOR[:top_left]
      [0,0,-n,-n] 
    when ANCHOR[:top_right]
      [n,0,-n,-n] 
    when ANCHOR[:bottom_left]
      [0,n,-n,-n] 
    when ANCHOR[:bottom_right]  
      [n,n,-n,-n] 
    when ANCHOR[:bottom]        
      [0,n,0,-n] 
    when ANCHOR[:left]
      [0,0,-n*2,0] 
    when ANCHOR[:right]  
      [n,0,-n,0] 
    when ANCHOR[:top]    
      [0,0,0,-n*2] 
    else
      raise(SurfaceError,'Invalid Anchor: %s' % anchor)
    end        
    self.x      += a[0]
    self.y      += a[1]
    self.width  += a[2]
    self.height += a[3]
    self
  end
  define_exfunc 'expand' do |n=0,anchor=5|
    contract! -n,anchor
  end
  define_exfunc 'squeeze' do |n=0,invert=false,orn=0|
    n = n.round 0
    unless invert
      self.x += n if orn==0 || orn==1
      self.y += n if orn==0 || orn==2
    end
    self.width  -= n if orn==0 || orn==1
    self.height -= n if orn==0 || orn==2
    self
  end
  define_exfunc 'release' do |n=1,invert=false,orn=0|
    squeeze! -n,invert,orn
  end
  define_exfunc 'xpush' do |n,anchor=-1|
    case anchor
    when -1 # // Do nothing!?
    when ANCHOR[:horz0]  
      self.x += n
    when ANCHOR[:horz], ANCHOR[:horz1]
      # // 
    when ANCHOR[:horz2]    
      self.x -= n
    when ANCHOR[:vert1]        
      self.y += n
    when ANCHOR[:vert], ANCHOR[:vert1]
      # // 
    when ANCHOR[:vert2]  
      self.y -= n    
    # // NUMPAD
    when ANCHOR[:center]
      # // N/A
    when ANCHOR[:top_left]
      self.x += n
      self.y += n
    when ANCHOR[:top_right]
      self.x -= n
      self.y += n
    when ANCHOR[:bottom_left]
      self.x += n
      self.y -= n
    when ANCHOR[:bottom_right]  
      self.x -= n
      self.y -= n
    when ANCHOR[:bottom]        
      self.y -= n
    when ANCHOR[:left]
      self.x -= n
    when ANCHOR[:right]  
      self.x += n
    when ANCHOR[:top]    
      self.y += n
    else
      raise(SurfaceError,'Invalid Anchor: %s' % anchor)
    end 
    self   
  end
  define_exfunc 'xpull' do |n=0,anchor=-1|
    xpush! -n,anchor
  end  
  define_exfunc 'salign' do |anchor=5,r=Graphics.rect|
    case anchor
    when -1 # // Do nothing!?
    when ANCHOR[:horz0]  
      self.x = r.x
    when ANCHOR[:horz], ANCHOR[:horz1]
      self.x = r.mid_x(self.rwidth)
    when ANCHOR[:horz2]    
      self.vx2 = r.vx2
    when ANCHOR[:vert1]        
      self.y = r.y
    when ANCHOR[:vert], ANCHOR[:vert1]
      self.y = r.mid_y(self.rheight)
    when ANCHOR[:vert2]      
      self.vy2 = r.vy2  
    # // NUMPAD
    when ANCHOR[:center]
      self.x = r.mid_x(self.rwidth)
      self.y = r.mid_y(self.rheight)
    when ANCHOR[:top_left]
      self.x   = r.x
      self.y   = r.y
    when ANCHOR[:top_right]
      self.vx2 = r.vx2
      self.y   = r.y
    when ANCHOR[:bottom_left]
      self.x   = r.x
      self.vy2 = r.vy2
    when ANCHOR[:bottom_right]  
      self.vx2 = r.vx2
      self.vy2 = r.vy2
    when ANCHOR[:bottom]        
      self.x   = r.mid_x(self.rwidth)
      self.vy2 = r.vy2
    when ANCHOR[:left]
      self.x   = r.x
      self.y   = r.mid_y(self.rheight)
    when ANCHOR[:right]  
      self.vx2 = r.vx2
      self.y   = r.mid_y(self.rheight)
    when ANCHOR[:top]    
      self.x   = r.mid_x(self.rwidth)
      self.y   = r.y
    end    
    self
  end  
  define_exfunc 'offset' do |n=1.0,anchor=7|
    case anchor
    when ANCHOR[:center]
      # // No move
    when ANCHOR[:top_left]
      self.vy += (self.rheight * n).to_i
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:top_right]
      self.vy += (self.rheight * n).to_i
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:bottom_left]
      self.vy -= (self.rheight * n).to_i
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:bottom_right]  
      self.vy -= (self.rheight * n).to_i
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:left]
      self.vx += (self.rwidth * n).to_i
    when ANCHOR[:top]  
      self.vy += (self.rheight * n).to_i
    when ANCHOR[:right]  
      self.vx -= (self.rwidth * n).to_i
    when ANCHOR[:bottom]      
      self.vy -= (self.rheight * n).to_i
    end
    self
  end
end 
#-inject gen_class_header 'Surface'
class Surface
  include MACL::Mixin::Surface
  def self.area_rect *objs
    mx = objs.min_by &:x
    my = objs.min_by &:y
    mw = objs.max_by &:vx2
    mh = objs.max_by &:vy2
    return Vector4.v4a_to_rect( [mx.x, my.y, mw.vx2, mh.vy2] )
  end 
  attr_accessor :x,:y,:width,:height
  def initialize x=0,y=0,width=0,height=0
    self.x,self.y,self.width,self.height = x, y, width, height
  end  
  def set *args
    obj,=args
    a = obj.respond_to?(:to_rect) ? obj.to_rect.to_a : args
    self.x,self.y,self.width,self.height = a
  end  
  def empty
    self.x = self.y = self.width = self.height = 0
  end
  def to_s
    "<#{self.class.name} x: #{x} y: #{y} width: #{width} height: #{height}>"
  end
end
def Surface.center r1,r2
  Rect.new r1.x+(r1.width-r2.width)/2,r1.y+(r1.height-r2.height)/2,r2.width,r2.height
end
#-inject gen_function_des 'Rect.fit_in'
def Surface.fit_in source,target
  w,h = source.width, source.height
  if w > h ; scale = target.width.to_f / w
  else     ; scale = target.height.to_f / h
  end
  r = source.dup;r.width,r.height=(w*scale).to_i,(h*scale).to_i;r
end
#-inject gen_class_header 'Rect'
class Rect
  include MACL::Mixin::Surface
end  
#-inject gen_class_header 'Vector4'
class Vector4
  include MACL::Mixin::Surface
  attr_accessor :x,:y,:width,:height
  def initialize *args
    _set *args
  end
  def _set x=nil,y=nil,w=nil,h=nil
    return self.x,self.y,self.width,self.height = 0,0,0,0 if [x,y,w,h].all? &:nil?
    return self.x,self.y,self.width,self.height = x.to_v4a if x.kind_of?(MACL::Mixin::Surface)
    self.x,self.y,self.width,self.height = x||@x||0,y||@y||0,w||@width||0,h||@height||0
  end
  private :_set
  def set *args
    _set *args
  end
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end  
  alias vx2 width
  alias vy2 height  
  def to_rect
    self.class.v4a_to_rect to_a
  end
  alias old_to_s to_s
  def to_s
    "<#{self.class.name} x#{x} y#{y} width#{width} height#{height}>"
  end
  def self.v4a_to_rect v4a
    return Rect.new v4a[0],v4a[1],v4a[2]-v4a[0],v4a[3]-v4a[1] 
  end  
end
#-inject gen_class_header 'Window'
class Window
  include MACL::Mixin::Surface
end  