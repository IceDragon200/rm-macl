#-unlessdef xMACLBUILD
#==============================================================================#
# ■ Surface
#==============================================================================#
# // • Created By    : IceDragon
# // • Modified By   : IceDragon
# // • Data Created  : 12/11/2011
# // • Data Modified : 01/20/2012
# // • Version       : 1.0
#==============================================================================#
# This module contains functions for checking the position, x, y within another
# object's area, this also includes methods for: 
#   Rect
#   Vector4 (Abstract of Rect)
#   Array
#
# Conversions
#==============================================================================#
# ● Change Log
#     ♣ 12/11/2011 V1.0 
#
# ● Change Log
#     ♣ 01/02/2012 V1.0 
#         Added
#           Surface.area_rect( *objs )
#           Vector4 (Class) < Rect
#             v4a_to_rect( v4a )
#     ♣ 01/02/2012 V1.0 
#         Added
#           vx=(n)
#           vy=(n)
#           vx2=(n)
#           vy2=(n)
#           set_vx(n)
#           set_vy(n)
#           set_vx2(n)
#           set_vy2(n)
#           set_vxy(x,y)
#           set_vxy2(x,y)
#           offset_vert(n=1.0)
#           offset_horz(n=1.0)
#==============================================================================# 
#-else:
  #-inject gen_module_header 'Mixin::Surface'
#-end:
#-inject gen_scr_imported_ww 'Surface', '0x10000'
module MACL::Mixin::Surface
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
  def vx=(n)
    self.x = n
  end
  def vy=(n)
    self.y = n
  end  
  def vwidth()
    self.vx + self.rwidth
  end  
  def vheight()
    self.vy + self.rheight
  end 
  def vx2
    vwidth
  end  
  def vy2
    vheight
  end  
  def vx2=( n )
    self.x = n - self.rwidth
  end  
  def vy2=( n )
    self.y = n - self.rheight
  end 
  def vset(x=nil,y=nil,x2=nil,y2=nil)
    self.vx = x  || self.vx
    self.vy = y  || self.vy
    self.vx2= x2 || self.vx2
    self.vy2= y2 || self.vy2
    self
  end    
  def to_a()   ;return self.vx, self.vy, self.rwidth, self.rheight;end
  def to_v4a() ;return self.vx, self.vy, self.vwidth, self.vheight;end
  def to_v4()  ;Vector4.new(*to_v4a());end
  def to_rect();Rect.new(*to_a());end
  alias rect to_rect
  # // 02/19/2012 [
  def salign(xn=-1,yn=-1,rx=0,ry=0,rwidth=Graphics.width,rheight=Graphics.height)
    case xn
    when -1; # // Do Nothing
    when 0 ; self.x = rx
    when 1 ; self.x = rx + ((rwidth - self.rwidth) / 2)
    when 2 ; self.vx2 = rwidth
    end
    case yn
    when -1; # // Do Nothing
    when 0 ; self.y = ry
    when 1 ; self.y = ry + ((rheight - self.rheight) / 2)
    when 2 ; self.vy2 = rheight
    end 
    self
  end  
  # // 02/19/2012 ]
  def offset_vert!(n=1.0)
    self.vy += (self.rheight * n).to_i
    self
  end  
  def offset_horz!(n=1.0)
    self.vx += (self.rwidth * n).to_i
    self
  end 
  def offset_vert(n=1.0)
    dup.offset_vert!(n)
  end  
  def offset_horz(n=1.0)
    dup.offset_horz!(n)
  end 
  def area
    rwidth * rheight
  end  
  def perimeter
    (rwidth * 2) + (rheight * 2)
  end 
  def space_x # // Clamp Space x offset
    0
  end
  def space_y # // Clamp Space y offset
    0
  end
  def space_width
    0
  end  
  def space_height
    0
  end  
  def clamp_to_space()
    v4 = (viewport || Graphics).rect.to_v4
    cx, cw = v4.x + space_x, v4.vwidth - self.rwidth - space_width
    cy, ch = v4.y + space_y, v4.vheight - self.rheight - space_height
    self.x, self.y = self.x.clamp(cx,cw), self.y.clamp(cy,ch)
  end 
  # . x . Only works with Padded stuff
  #def _surface_padding()
  #  (respond_to?(:padding) ? padding : 0)
  #end  
  def _surface_padding()
    standard_padding
  end  
  def adjust_x4contents(x,pad=_surface_padding)
    x + pad
  end  
  def adjust_y4contents(y,pad=_surface_padding)
    y + pad
  end  
  def adjust_w4contents(w,pad=_surface_padding)
    w - (pad * 2)
  end  
  def adjust_h4contents(h,pad=_surface_padding)
    h - (pad * 2)
  end
  def adjust_xywh4contents(x,y,w,h)
    return [adjust_x4contents(x),adjust_y4contents(y),adjust_w4contents(w),adjust_h4contents(h)]
  end
  def adjust_rect4contents(rect) 
    Rect.new(*adjust_xywh4contents(*rect.to_a))
  end  
  def adjust_x4window(x,pad=_surface_padding)
    x - pad
  end  
  def adjust_y4window(y,pad=_surface_padding)
    y - pad
  end  
  def adjust_w4window(w,pad=_surface_padding)
    w + (pad * 2)
  end  
  def adjust_h4window(h,pad=_surface_padding)
    h + (pad * 2)
  end
  def adjust_xywh4window(x,y,w,h)
    return [adjust_x4window(x),adjust_y4window(y),adjust_w4window(w),adjust_h4window(h)]
  end
  def adjust_rect4contents(rect) 
    Rect.new(*adjust_xywh4window(*rect.to_a))
  end  
  # O_O
  def calc_pressure_horz( n, invert=false )
    return 0 if n < self.x || n > self.vwidth
    n = n - self.x
    n2 = (self.vwidth - self.x)
    n = n2 - n if invert
    n = n / n2.to_f
    return n
  end
  def calc_pressure_vert( n, invert=false )
    return 0 if n < self.y || n > self.vheight
    n = n - self.y
    n2 = (self.vheight - self.y)
    n = n2 - n if invert
    n = n / n2.to_f
    return n
  end
  def in_area?( ax, ay )
    return ax.between?( self.vx, self.vwidth ) && 
      ay.between?( self.vy, self.vheight )
  end 
  def intersect?( v4 )  
    return in_area?( v4.x, v4.y ) || in_area?( v4.width, v4.height )
  end  ##
end 
#-inject gen_class_header 'Surface'
class Surface
  include MACL::Mixin::RectExpansion
  include MACL::Mixin::RectExpansion::RectOnly
  include MACL::Mixin::Surface
  def self.area_rect( *objs )
    mx = objs.min { |a, b| a.x <=> b.x }
    my = objs.min { |a, b| a.y <=> b.y }
    mw = objs.max { |a, b| a.vwidth <=> b.vwidth }
    mh = objs.max { |a, b| a.vheight <=> b.vheight }
    return Vector4.v4a_to_rect( [mx.x, my.y, mw.vwidth, mh.vheight] )
  end 
  def initialize(x=0,y=0,width=0,height=0)
    self.x,self.y,self.width,self.height = x, y, width, height
  end  
  def set(*args)
    obj,=args
    a = (obj.respond_to?(:to_rect)) ? obj.to_rect.to_a : args
    self.x,self.y,self.width,self.height = a
  end  
end
#-inject gen_class_header 'Rect'
class Rect
  include MACL::Mixin::Surface
end  
#-inject gen_class_header 'Vector4'
class Vector4 < Rect
  def rwidth
    self.width - self.x
  end
  def rheight
    self.height - self.y
  end  
  def vwidth
    self.width
  end  
  def vheight
    self.height
  end  
  def self.v4a_to_rect( v4a )
    return Rect.new( v4a[0], v4a[1], v4a[2]-v4a[0], v4a[3]-v4a[1] )
  end  
end
#-inject gen_class_header 'Window'
class Window
  include MACL::Mixin::Surface
end  
#-inject gen_class_header 'Sprite'
class Sprite
  include MACL::Mixin::Surface
end  