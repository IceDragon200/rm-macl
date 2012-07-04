#==============================================================================#
# ■ Mixin::RectExpansion
#==============================================================================#
# // • Created By    : IceDragon
# // • Modified By   : IceDragon
# // • Data Created  : 12/20/2011
# // • Data Modified : 01/04/2012
# // • Version       : 1.1
#==============================================================================#
# ● Change Log
#     ♣ 12/20/2011 V1.0
#         Added
#           contract!( n )
#           expand!( n )
#           contract( n )
#           expand( n )
#           to_a()
#
#     ♣ 12/28/2011 V1.0
#         Added
#           contract_horz!( n )
#           contract_vert!( n )
#           contract_horz( n )
#           contract_vert( n )
#           expand_horz!( n )
#           expand_vert!( n )
#           expand_horz( n )
#           expand_vert( n )
#
#     ♣ 01/02/2012 V1.0
#         Added
#           Rect.center( parent_rect, child_rect )
#           center( child_rect )
#
#     ♣ 01/02/2012 V1.0
#         Added
#           squeeze_vert( n, invert=false )
#           squeeze_vert!( n, invert=false )
#           squeeze_horz( n, invert=false )
#           squeeze_horz!( n, invert=false )
#           release_vert( n, invert=false )
#           release_vert!( n, invert=false )
#           release_horz( n, invert=false )
#           release_horz!( n, invert=false )
#     ♣ 04/14/2012 V1.0
#         Changed
#           squeeze()
#           release()
#
#==============================================================================#
warn 'RectExpansion is already imported' if ($imported||={})['RectExpansion']
($imported||={})['RectExpansion']=0x10000
# ─┤ ● Rect.center ├──────────────────────────────────────────────────────────
def Rect.center r1,r2
  Rect.new r1.x+(r1.width-r2.width)/2,r1.y+(r1.height-r2.height)/2,r2.width,r2.height
end
# ─┤ ● Rect.fit_in ├──────────────────────────────────────────────────────────
def Rect.fit_in source,target
  w,h = source.width, source.height
  if w > h ; scale = target.width.to_f / w
  else     ; scale = target.height.to_f / h
  end
  r = source.dup;r.width,r.height=(w*scale).to_i,(h*scale).to_i;r
end
# ╒╕ ■                                           MACL::Mixin::RectExpansion ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL::Mixin::RectExpansion
  SYM_ARGS = [:x,:y,:width,:height]
  def center child_rect
    Rect.center self, child_rect
  end
  def to_a
    return self.x, self.y, self.width, self.height
  end
  def xto_a *args,&block
    (args&SYM_ARGS).collect(&(block_given? ? block : proc{|sym|self.send(sym)}))
  end
  def xto_h *args
    Hash[xto_a(*args){|sym|[sym,self.send(sym)]}]
  end
  def cx
    x+width/2
  end
  def cy
    y+height/2
  end
  # // Destructive
  def contract! n=0,orn=0
    self.x      += n   if(orn==0 || orn==1)
    self.y      += n   if(orn==0 || orn==2)
    self.width  -= n*2 if(orn==0 || orn==1)
    self.height -= n*2 if(orn==0 || orn==2)
    self
  end
  def expand! n=0
    contract! -n
  end
  def squeeze! n=0,invert=false,orn=0
    n = n.round 0
    unless invert
      self.x += n if orn==0 || orn==1
      self.y += n if orn==0 || orn==2
    end
    self.width  -= n if orn==0 || orn==1
    self.height -= n if orn==0 || orn==2
    self
  end
  def release! n=1,invert=false,orn=0
    squeeze! -n,invert,orn
  end
  def xpush! n,orn=0
    self.x += n if orn==0 || orn==1
    self.y += n if orn==0 || orn==2
    self
  end
  def xpull! n,orn=0
    xpush! -n,orn
  end
# ╒╕ ■                                                             RectOnly ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  module RectOnly
    def xset x=nil,y=nil,w=nil,h=nil
      x,y,w,h = x.get_values(:x,:y,:width,:height) if(x.is_a?(Hash))
      set(x||self.x,y||self.y,w||self.width,h||self.height);self
    end
    # // . x . Dup
    def contract n=1,orn=0
      dup.contract! n,orn
    end
    def expand n=1,orn=0
      dup.expand! n,orn
    end
    def squeeze n=1,invert=false,orn=0
      dup.squeeze! n,invert,orn
    end
    def release n=1,invert=false,orn=0
      dup.release! n,invert,orn
    end
    # // 03/05/2012
    def xpush n,orn=0
      dup.xpush! n,orn
    end
    def xpull n,orn=0
      dup.xpull! n,orn
    end
  end
end