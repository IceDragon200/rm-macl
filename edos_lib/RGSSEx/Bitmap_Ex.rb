warn 'Bitmap_Ex is already imported' if ($imported||={})['Bitmap_Ex']
($imported||={})['Bitmap_Ex']=0x10002
# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx=ny=x=y=0
    while nodes.size > 0
      x,y = nodes.shift
      next unless x and y
      next if table[x,y] > 0
      set_pixel(x,y,color) 
      table[x,y] = 1
      for iy in -1..1
        for ix in -1..1
          nx,ny = x+ix,y+iy
          next if table[nx,ny].to_i > 0
          next unless get_pixel(nx,ny) == base_color
          nodes << [nx,ny] 
        end
      end
      yield if block_given? 
    end
  end
  def recolor f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate_do { |x,y,color| set_pixel(x,y,hsh[color]||color) }
  end 
  def iterate_map 
    iterate_do { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
  end
  def legacy_recolor color1,color2
    for y in 0...height
      for x in 0...width
        set_pixel x,y,color2 if get_pixel(x,y) == color1
      end
    end
  end 
  def palletize 
    pallete = Set.new
    iterate_do true do |x,y,color| pallete << color.to_a end
    pallete.to_a.sort.collect do |a|Color.new *a end
  end  
  def iterate_do return_only=false 
    x, y = nil, nil
    for y in 0...height
      for x in 0...width
        yield x,y,get_pixel(x,y) 
      end
    end   
  end 
  def draw_line point1,point2,color,weight
    x1,y1 = point1.to_a
    x2,y2 = point2.to_a
    dx = x2 - x1
    dy = y2 - y1
    sx = x1 < x2 ? 1 : -1
    sy = y1 < y2 ? 1 : -1
    err= (dx-dy).to_f
    e2 = 0
    loop do
      set_pixel_weighted x1,x2,color,weight 
      break if x1 == x2 and y1 == y2 
      e2 = 2*err
      if e2 > -dy 
        err = err - dy
        x1  = x1 + sx  
      end
      if e2 < dx 
        err = err + dx
        y1  = y1 + sy 
      end
    end  
  end
  def set_pixel_weighted x,y,color,weight=1
    weight.times do |i| set_pixel(x,y+i,color) end
  end
end