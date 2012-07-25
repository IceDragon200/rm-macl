# DrawExt
#==============================================================================#
# ■ DrawExt
#==============================================================================#
# // • Created By    : IceDragon
# // • Modified By   : IceDragon
# // • Data Created  : 12/08/2011
# // • Data Modified : 12/08/2011
# // • Version       : 1.0
#==============================================================================#
# ● Change Log
#     ♣ 12/08/2011 V1.0
#
#==============================================================================#
module DrawExt
  def self.calc_color_diff( color1, color2, rate=0.0 )
    return color1.transition_to( color2, rate )
  end 
  def self.bar_color_diff( set1, set2, rate=0.0 )
    result = {}
    (set1.keys | set2.keys).each { |key|
      color1 = set1[key] 
      color2 = set2[key] 
      color1 ||= color2 || Color.new( 0, 0, 0 )
      color2 ||= color1 || Color.new( 0, 0, 0 )
      result[key] = calc_color_diff( color1, color2, rate )
    }
    return result
  end  
  def self._bar_merge_info( info )
    bitmap        = info[:bitmap]
    width         = info[:width] || (bitmap ? bitmap.width : 128)
    rate          = info[:rate] || 1.0
    padding       = info[:padding] || 1
    return info.merge(
      #:bitmap        => info[:bitmap],
      #:base_method   => info[:base_method],
      #:bar_method    => info[:bar_method],
      :x             => info[:x] || 0,
      :y             => info[:y] || 0,
      :width         => width,
      :height        => info[:height] || (bitmap ? bitmap.height : 24),
      :padding       => padding,
      :rate          => rate,
      :base_outline1 => info[:base_outline1] || DEF_BAR_COLORS[:base_outline1],
      :base_outline2 => info[:base_outline2] || DEF_BAR_COLORS[:base_outline2],
      :base_inner1   => info[:base_inner1]   || DEF_BAR_COLORS[:base_inner1],
      :base_inner2   => info[:base_inner2]   || DEF_BAR_COLORS[:base_inner2],
      :bar_outline1  => info[:bar_outline1]  || DEF_BAR_COLORS[:bar_outline1],
      :bar_outline2  => info[:bar_outline2]  || DEF_BAR_COLORS[:bar_outline2],
      :bar_inner1    => info[:bar_inner1]    || DEF_BAR_COLORS[:bar_inner1],
      :bar_inner2    => info[:bar_inner2]    || DEF_BAR_COLORS[:bar_inner2],
      :bar_highlight => info[:bar_highlight] || DEF_BAR_COLORS[:bar_highlight]
    )
  end  
  def self.get_gauge_base( info )
    color1 = info[:base_outline1] || DEF_BAR_COLORS[:base_outline1]
    color2 = info[:base_outline2] || DEF_BAR_COLORS[:base_outline2]
    color3 = info[:base_inner1]   || DEF_BAR_COLORS[:base_inner1]
    color4 = info[:base_inner2]   || DEF_BAR_COLORS[:base_inner2]
    width, height = info[:width] || 128, info[:height] || 24    
    padding       = info[:padding] || 1
    base = Bitmap.new( width, height )
    rect = Rect.new( 0, 0, base.width, base.height )
    base.gradient_fill_rect( rect, color1, color2, true )
    rect = Rect.new( padding, padding, base.width-(padding*2), base.height-(padding*2) )
    base.clear_rect( rect )
    base.gradient_fill_rect( rect, color3, color4, true )
    return base
  end  
  def self.get_gauge_bar( info )
    color5   = info[:bar_outline1]  || DEF_BAR_COLORS[:bar_outline1]
    color6   = info[:bar_outline2]  || DEF_BAR_COLORS[:bar_outline2]
    color7   = info[:bar_inner1]    || DEF_BAR_COLORS[:bar_inner1]
    color8   = info[:bar_inner2]    || DEF_BAR_COLORS[:bar_inner2]
    color9   = info[:bar_highlight] || DEF_BAR_COLORS[:bar_highlight]
    width    = info[:width]    || 128
    height   = info[:height]   || 24
    rate     = info[:rate]     || 1.0
    padding  = info[:padding]  || 1
    # // 0 - Horz, 1 - Vert, 2 - Diagnol (Experimental)
    orn      = info[:orn] || 0 
    style    = info[:style] || 0
    case(orn)
    when 0
      barlength = width * rate
      bw, bh = [barlength, height]
    when 1
      barlength = height * rate
      bw, bh = [width, barlength]
    else
      raise "Bad orientation '#{orn}'"
    end  
    gvert = orn == 0
    case(style)
    when 1
      bmp   = Bitmap.new( bw.max(1),bh.max(1) )
      tbmp  = Bitmap.new( bmp.width, bmp.height )
      rect  = Rect.new( 0, 0, bw, bh )
      rect2 = rect.contract(padding)
      rect2.width=rect2.width.max(0);rect2.height=rect2.height.max(0)
      rect3 =(
      case(orn)
      when 0;Rect.new( 0, 0, bw, bh/2 )
      when 1;Rect.new( 0, 0, bw/2, bh )
      end)  
      bmp.gradient_fill_rect( rect, color5, color6, gvert )
      bmp.clear_rect( rect2 )
      bmp.gradient_fill_rect( rect2, color7, color8, gvert )
      tbmp.fill_rect( rect3, color9 ) #; tbmp.blur
      bmp.blt(0,0,tbmp,tbmp.rect)
    when 2
      (color9 = color9.clone).alpha *= 3.2
      bmp   = Bitmap.new(bw.max(1),bh.max(1))
      tbmp  = Bitmap.new(bmp.width,bmp.height)
      rect3 = Rect.new(0,0,bw,bh).contract(1)
      case(orn)
      when 0
        rect  = Rect.new(0,0,bw,bh/2)
        rect2 = rect.clone.xset(:y=>rect.height)
        rect4 = rect3.clone.xset(:height=>rect3.height/2)
        rect5 = rect4.clone.xset(:y=>rect4.height+1)
        rect6 = rect.clone #3.clone.xset(:height=>rect3.height/2)
      when 1
        rect  = Rect.new(0,0,bw/2,bh)
        rect2 = rect.clone.xset(:x=>rect.width)
        rect4 = rect3.clone.xset(:width=>rect3.width/2)
        rect5 = rect4.clone.xset(:x=>rect4.width+1)
        rect6 = rect.clone#3.clone.xset(:width=>rect3.width/2)
      end  
      bmp.gradient_fill_rect( rect, color5, color6, gvert )
      bmp.gradient_fill_rect( rect2, color6, color5, gvert )
      bmp.clear_rect( rect3 )
      bmp.gradient_fill_rect( rect4, color7, color8, gvert )
      bmp.gradient_fill_rect( rect5, color8, color7, gvert )
      tbmp.fill_rect( rect6, color9 ) #; tmp.blur
      bmp.blt(0,0,tbmp,tbmp.rect)
    when 3
      bmp       = Bitmap.new(width,height)
      divisions = info[:divisions] || 10
      barcount  = info[:barcount] || (divisions * rate)
      spacing   = info[:spacing] || 1
      bw2,bh2 = bw,bh
      case(orn)
      when 0
        bw2 = ((width-(spacing*divisions))/divisions.max(1).to_f).round(0)
      when 1
        bh2 = ((height-(spacing*divisions))/divisions.max(1).to_f).round(0)
      end  
      exinfo = info.merge(
        :width        => bw2,
        :height       => bh2,
        :rate         => 1.0,
        :padding      => padding,
        :barseg_style => 0,
        :style        => info[:barseg_style]
      )
      segbar = get_gauge_bar( exinfo )
      case(orn)
      when 0
        for i in 0...barcount;bmp.blt(i*(bw2+spacing),0,segbar,segbar.rect);end
      when 1
        for i in 0...barcount;bmp.blt(0,i*(bh2+spacing),segbar,segbar.rect);end
      end    
      segbar.dispose()
    when 4
      bmp   = Bitmap.new(bw.max(1),bh.max(1))
      case(orn)
      when 0
        rect  = Rect.new(0,0,bw,bmp.height/4)
        rect2 = rect.xpush(rect.height,2)
        rect3 = rect2.xpush(rect2.height,2)
        rect4 = rect3.xpush(rect3.height,2)
      when 1
        rect  = Rect.new(0,0,bmp.width/4,bh)
        rect2 = rect.xpush(rect.height,1)
        rect3 = rect2.xpush(rect2.height,1)
        rect4 = rect3.xpush(rect3.height,1)
      end  
      bmp.fill_rect( rect, color6 )
      bmp.fill_rect( rect2, color5 )
      bmp.fill_rect( rect3, color8 )
      bmp.fill_rect( rect4, color7 )
    end 
    # // 0 - Left||Up to Right||Down, 1- Right||Down to Left||Up
    # // 2 - Middle
    gaugem   = info[:gaugem] || 0
    if(gaugem > 0)
      tmp = bmp
      bmp = Bitmap.new(width,height)
      if(gaugem==1)
        bmp.blt(bmp.width-tmp.width,bmp.height-tmp.height,tmp,tmp.rect)
      elsif(gaugem==2)
        bmp.blt((bmp.width-tmp.width)/2,(bmp.height-tmp.height)/2,tmp,tmp.rect)
      end 
      tmp.dispose
    end
    return bmp
  end   
  def self.adjust_size4bar3(size, divs, spacing, padding)
    (((size/divs.to_f()).round(0)*divs)+(divs*spacing)+(padding*2)).to_i
  end  
  def self.adjust_size4bar4(size, padding)
    adjust_size4bar3(size, 4, 0, padding)
  end  
  # // Legacy Support
  class << self
    def get_bar1_base(info)
      get_gauge_base(info)
    end
    alias get_bar2_base get_bar1_base
    alias get_bar3_base get_bar1_base
    alias get_bar4_base get_bar1_base
    def get_bar1_bar(info)
      get_gauge_bar(info.merge(:style=>1))
    end  
    def get_bar2_bar(info)
      get_gauge_bar(info.merge(:style=>2))
    end  
    def get_bar3_bar(info)
      get_gauge_bar(info.merge(:style=>3))
    end  
    def get_bar4_bar(info)
      get_gauge_bar(info.merge(:style=>4))
    end  
  end  
  def self._draw_bar( merge_info )
    base    = merge_info[:base_method].call( merge_info )
    merge_info2 = merge_info.merge(Rect.new(*merge_info.get_values(:x,:y,:width,:height)).contract(merge_info[:padding]).xto_h(*Rect::SYM_ARGS))
    bar     = merge_info[:bar_method].call( merge_info2 )
    bitmap  = merge_info[:bitmap]
    x, y    = merge_info[:x], merge_info[:y]
    padding = merge_info[:padding]
    if merge_info[:return_only] == true
      return base, bar
    else  
      bitmap.blt( x, y, base, base.rect )
      bitmap.blt( x+padding, y+padding, bar, bar.rect )
      base.dispose() 
      bar.dispose()
      return nil
    end  
  end  
  def self.draw_bar1( info )
    add_info = { :base_method => public_method( :get_bar1_base ),
                 :bar_method  => public_method( :get_bar1_bar ) }
    return _draw_bar( _bar_merge_info( info ).merge( add_info ) )
  end 
  def self.draw_bar2( info )
    add_info = { :base_method => public_method( :get_bar2_base ),
                 :bar_method  => public_method( :get_bar2_bar ) }
    return _draw_bar( _bar_merge_info( info ).merge( add_info ) )
  end 
  def self.draw_bar3( info )
    add_info = { :base_method   => public_method( :get_bar3_base ),
                 :bar_method    => public_method( :get_bar3_bar ), 
                 :barseg_style  => info[:barseg_style] || 1, }
    return _draw_bar( _bar_merge_info( info ).merge( add_info ) )
  end 
  def self.draw_bar4( info )
    add_info = { :base_method => public_method( :get_bar4_base ),
                 :bar_method  => public_method( :get_bar4_bar ) }
    return _draw_bar( _bar_merge_info( info ).merge( add_info ) )
  end 
  def self._box_merge_info( info )
    return info.merge( {
      :no_merge      => true,
      :bitmap        => info[:bitmap],
      :x             => info[:x] || 0,
      :y             => info[:y] || 0,
      :width         => [info[:width]  || 32, 1].max,
      :height        => [info[:height] || 32, 1].max,
      :padding       => info[:padding]       || 1,
      :base_color    => info[:base_color]    || Pallete[:paper2],
      :padding_color => info[:padding_color] || Pallete[:brown2],
      :footer_color  => info[:footer_color]  || Pallete[:brown2]
    } )
  end  
  def self.draw_box1( info )
    info = _box_merge_info( info ) unless info[:no_merge]
    bitmap        = info[:bitmap]
    x, y          = info[:x], info[:y]
    width, height = info[:width], info[:height]
    padding       = info[:padding]
    base_color    = info[:base_color]
    padding_color = info[:padding_color]
    fullpad = padding * 2
    base, border  = Bitmap.new( width, height ), Bitmap.new( width, height ) 
    rect = Rect.new( padding, padding, base.width-fullpad, base.height-fullpad )
    base.fill_rect( rect, base_color )
    border.fill_rect( 0, 0, border.width, border.height, padding_color )  
    border.clear_rect( rect )
    if info[:return_only] == true
      return base, border
    else  
      bitmap.blt( x, y, base, base.rect )
      bitmap.blt( x, y, border, border.rect )
      base.dispose()
      border.dispose()
    end  
  end
  def self.draw_box2( info )
    info = _box_merge_info( info ) unless info[:no_merge]
    bitmap        = info[:bitmap]
    x, y          = info[:x], info[:y]
    width, height = info[:width], info[:height]
    footer_height = info[:footer_height] || info[:padding]
    footer_color  = info[:footer_color]
    base, border  = *draw_box1( info.merge( { :return_only => true } ) )
    footer = Bitmap.new( width, height )
    footer.fill_rect( 0, 
      footer.height-footer_height, footer.width, footer_height, footer_color )
    if info[:return_only] == true
      return base, border, footer
    else  
      bitmap.blt( x, y, base, base.rect )
      bitmap.blt( x, y, border, border.rect )
      bitmap.blt( x, y, footer, footer.rect )
      base.dispose()
      border.dispose()
      footer.dispose()
    end   
  end
  def self.draw_box3( info )
    info = _box_merge_info( info ) unless info[:no_merge]
    bitmap        = info[:bitmap]
    x, y          = info[:x], info[:y]
    width, height = info[:width], info[:height]
    padding       = info[:padding] || 1
    footer_height = info[:footer_height] || padding
    base_color    = info[:base_color] || Pallete[:brown2]
    fullpad = padding * 2
    bmp = Bitmap.new( width, height )
    color = base_color.clone
    color.alpha = 48
    bmp.fill_rect( 0, 0, bmp.width, bmp.height, color )
    color.alpha = 72
    bmp.fill_rect( padding, padding, bmp.width-fullpad, bmp.height-fullpad, color )
    color.alpha = 128
    bmp.fill_rect( 0, bmp.height-footer_height, bmp.width, footer_height, color )
    if info[:return_only] == true
      return bmp
    else  
      bitmap.blt( x, y, bmp, bmp.rect )
      bmp.dispose()
    end
  end  
  INTELI_REPEAT = true  
if INTELI_REPEAT
  def self.repeat_bmp_vert( info )
    length        = info[:length] || 0
    return if length == 0
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    opacity       = info[:opacity] || 255
    reps, tail = *length.divmod(rect.height.to_i)
    reps.times do |i| bitmap.blt(x,y+(rect.height*i),dbmp,rect,opacity) ; end
    r = rect.dup ; r.height = tail
    bitmap.blt( x, y+(reps*rect.height), dbmp, r )
  end
  def self.repeat_bmp_horz( info )
    length        = info[:length] || 0
    return if length == 0
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    opacity       = info[:opacity] || 255
    reps, tail = *length.divmod(rect.width.to_i)
    reps.times do |i| bitmap.blt( x+(rect.width*i), y, dbmp, rect,opacity ) ; end
    r = rect.dup ; r.width = tail
    bitmap.blt( x+(reps*rect.width), y, dbmp, r )
  end
  def self.repeat_bmp( info )
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    width         = info[:width] || bitmap.width
    height        = info[:height] || bitmap.height
    opacity       = info[:opacity] || 255
    repsx, tailx = *width.divmod(rect.width.to_i)
    repsy, taily = *height.divmod(rect.height.to_i)
    r = Rect.new(0,0,0,0)
    return if [repsx, repsy, tailx, taily].all? { |n| n.zero? }
    if repsx.zero? && repsy.zero? # // Only Tails
      r.set(rect.x,rect.y,tailx,taily)
      bitmap.blt(x,y,dbmp,r,opacity)
    elsif repsx.zero? && repsy > 0 # // No x repeat but y and tails
      for dy in 0...repsy
        r.set(rect) ; r.width = tailx
        bitmap.blt(x,y+(dy*rect.height),dbmp,r,opacity) # (: Yay
      end if tailx > 0
      if taily > 0
        r.set(rect) ; r.height = taily
        bitmap.blt(x,y+(repsy*rect.height),dbmp,r,opacity) # (: Yay
      end
    elsif repsx > 0 && repsy.zero? # // No y repeat but x and tails
      for dx in 0...repsx
        r.set(rect) ; r.height = taily
        bitmap.blt(x+(dx*rect.width),y,dbmp,r,opacity) # (: Yay
      end if taily > 0 
      if tailx > 0
        r.set(rect) ; r.width = tailx
        bitmap.blt(x+(repsx*rect.width),y,dbmp,r,opacity) # (: Yay
      end  
    else # // Full Repeat
      for dy in 0...repsy
        if tailx > 0
          r.set(rect) ; r.width = tailx
          bitmap.blt(x+(repsx*rect.width),y+(dy*rect.height),dbmp,r,opacity) # (: Yay
        end
        for dx in 0...repsx
          bitmap.blt(x+(dx*rect.width),y+(dy*rect.height),dbmp,rect,opacity) # (: Yay
          if taily > 0
            r.set(rect) ; r.height = taily
            bitmap.blt(x+(dx*rect.width),y+(repsy*rect.height),dbmp,r,opacity) # (: Yay
          end  
        end  
      end
      # // End Tail      
      bitmap.blt(x+(repsx*rect.width),y+(repsy*rect.height),dbmp,r,opacity) if tailx > 0 && taily > 0
    end  
  end
else # // Loop Repeat  
  def self.repeat_vert_func( i, r )
    (i % r.height)
  end  
  def self.repeat_horz_func( i, r )
    (i % r.width)
  end  
  def self.repeat_full_func( x, y, r )
    return (x % r.width), (y % r.height)
  end
  def self.repeat_bmp_vert( info, &block )
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    length        = info[:length] || 0
    block ||= method(:repeat_vert_func)
    r = rect.clone
    0.upto( length ) do |i|
      r = rect.clone ; r.y += block.call(i,r) ; r.height = 1
      bitmap.blt( x, y+i, dbmp, r )
    end
  end
  def self.repeat_bmp_horz( info, &block )
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    length        = info[:length] || 0
    block ||= method(:repeat_horz_func)
    r = rect.clone
    0.upto( length ) do |i|
      r = rect.clone ; r.x += block.call(i,r) ; r.width = 1
      bitmap.blt( x+i, y, dbmp, r )
    end
  end
  def self.repeat_bmp( info, &block )
    bitmap        = info[:bitmap]
    dbmp          = info[:draw_bmp]
    rect          = info[:rect]
    x, y          = info[:x] || 0, info[:y] || 0
    width         = info[:width] || bitmap.width
    height        = info[:height] || bitmap.height
    tx, ty = 0, 0
    bx, by = 0, 0
    block ||= method(:repeat_full_func)
    for dy in 0...height
      for dx in 0...width
        tx, ty = x + dx, y + dy
        bx, by = *block.call(dx, dy, r) 
        bitmap.blt( tx,ty,dbmp,Rect.new(bx,by,1,1)) # D: OMFG!? Why the hell!?
      end  
    end  
  end
end # // INTELI_REPEAT
  def self.crop( bitmap, rect )
    b = Bitmap.new(*rect.xto_a(:width,:height));b.blt(0,0,bitmap,rect);b
  end  
  def self.clear_round( bitmap, rect )
    b=bitmap.dup;b.ext_clear_round!(rect);b
  end  
  def self.clear_round!( bitmap, rect )
    temp = Bitmap.new(*rect.xto_a(:width,:height))
    temp.blt(0,0,bitmap,rect)
    bitmap.clear ; bitmap.blt(rect.x,rect.y,temp,temp.rect)
    temp.dispose
  end 
  def self.alpha_mask( info={} )
    bitmap = info[:bitmap]
    if alpha_rect=info[:alpha_rect]
      a = info[:alpha_value] || 128
      for y in alpha_rect.y...alpha_rect.vy2
        for x in alpha_rect.x...alpha_rect.vx2
          bitmap.set_pixel(x,y,bitmap.get_pixel(x,y).xset(:alpha=>a))
        end  
      end  
    elsif bmp=info[:alpha_bitmap]  
      r = info[:rect] || bmp.rect
      px, py = 0, 0 
      for y in 0...r.height
        for x in 0...r.width
          px, py = x + r.x, y + r.y
          bitmap.set_pixel(px,py,bitmap.get_pixel(px,py).xset(:alpha=>bmp.get_pixel(x,y).alpha))
        end
      end  
    end  
  end  
#==============================================================================#
# ◙ Experimental Functions
#/============================================================================\#
# ● Functions in this section should be used with care.
#   In addition they are never included with the DrawExt::Include module
#\============================================================================/#  
  def self.draw_diamond( info )
    bitmap        = info[:bitmap]
    color         = info[:color] || Color.new( 20, 20, 20 )
    x, y          = info[:x] || 0, info[:y] || 0
    width, height = info[:width] || 32, info[:height] || 32
    bmp = Bitmap.new( width, height )
    hw, hh = (width/2), (height/2)
    if info[:hollow] == true
      for dx in 0...hw
        bmp.set_pixel( hw-dx, dx, color )
        bmp.set_pixel( hw+(hw-dx), hh-dx, color )
        bmp.set_pixel( dx, hh+(dx), color )
        bmp.set_pixel( hw+dx, hh+(hh-dx), color )
      end  
    else
      for dx in 0...hw
        for dy in 0...hh
          bmp.set_pixel( hw+dx, dy, color ) if dx < dy
          bmp.set_pixel( dx, hh+dy, color ) if dy < dx
          bmp.set_pixel( dx, hh-dy, color ) if dy < dx
          bmp.set_pixel( hw+hw-dx-1, hh+dy, color ) if dy < dx
        end  
      end
    end  
    if info[:return_only] == true
      return bmp
    else  
      bitmap.blt( x, y, bmp, bmp.rect )
    end  
  end 
end
#==============================================================================#
# ■ DrawExt::Include
#==============================================================================#
module DrawExt::Include
  def ext_draw_bar!( info ) # // RAW .x. You need to set all the info yourself
    ::DrawExt._draw_bar( _ext_set_bitmap(info) )
  end  
  def ext_draw_bar1( info )
    ::DrawExt.draw_bar1( _ext_set_bitmap( info ) )
  end
  def ext_draw_bar2( info )
    ::DrawExt.draw_bar2( _ext_set_bitmap( info ) )
  end
  def ext_draw_bar3( info )
    ::DrawExt.draw_bar3( _ext_set_bitmap( info ) )
  end
  def ext_draw_bar4( info )
    ::DrawExt.draw_bar4( _ext_set_bitmap( info ) )
  end 
  def ext_draw_box1( info )
    ::DrawExt.draw_box1( _ext_set_bitmap( info ) )
  end
  def ext_draw_box2( info )
    ::DrawExt.draw_box2( _ext_set_bitmap( info ) )
  end
  def ext_draw_box3( info )
    ::DrawExt.draw_box3( _ext_set_bitmap( info ) )
  end
  def ext_repeat_bmp_vert( info )
    ::DrawExt.repeat_bmp_vert( _ext_set_bitmap( info ) )
  end  
  def ext_repeat_bmp_horz( info )
    ::DrawExt.repeat_bmp_horz( _ext_set_bitmap( info ) )
  end
  def ext_repeat_bmp( info )
    ::DrawExt.repeat_bmp( _ext_set_bitmap( info ) )
  end  
  def ext_crop( rect )
    ::DrawExt.crop( _ext_drawing_bitmap, rect )
  end
  def ext_clear_round( rect )
    ::DrawExt.clear_round( _ext_drawing_bitmap, rect )
  end  
  def ext_clear_round!( rect )
    ::DrawExt.clear_round!( _ext_drawing_bitmap, rect )
  end
  def ext_alpha_mask( info )
    ::DrawExt.alpha_mask( _ext_set_bitmap( info ) )
  end
  private
  def _ext_drawing_bitmap()
  end
  def _ext_dbmp()
    _ext_drawing_bitmap()
  end  
  def _ext_set_bitmap( info )
    info[:bitmap] ||= _ext_drawing_bitmap()
    info
  end
end 
#==============================================================================#
# ♥ Bitmap
#==============================================================================#
class Bitmap
  include DrawExt::Include
  def _ext_drawing_bitmap()
    return self
  end  
end  
#==============================================================================#
# ♥ Artist
#==============================================================================#
class Artist
  include DrawExt::Include
  def _ext_drawing_bitmap()
    canvas
  end
end  
=begin
#==============================================================================#
# ♥ Sprite
#==============================================================================#
class Sprite
  include DrawExt::Include
  def _ext_drawing_bitmap()
    return self.bitmap
  end  
end  
#==============================================================================#
# ♥ Window
#==============================================================================#
class Window::Base < Window
  include DrawExt::Include
  def _ext_drawing_bitmap()
    return contents
  end  
end  
=end
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#
