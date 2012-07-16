# ╒╕ ♥                                                               Bitmap ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Bitmap
  def fill sx,sy,color=Color.new(255,255,255,255)
    base_color = get_pixel sx,sy
    nodes = []
    nodes << [sx,sy]
    table = Table.new width,height 
    nx = ny = x = y =0
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
    end
  end
  def recolor! f_color,t_color=nil 
    if f_color.is_a? Color and t_color.is_a? Color 
      hsh = { f_color => t_color }
    elsif f_color.is_a? Array && t_color 
      arra = t_color.is_a? Enumerable ? t_color : [t_color]*f_color.size 
      hsh = {};f_color.each_with_index{|c,i|hsh[c]=arra[i]}
    else  
      hsh = f_color
    end  
    x,y,color = nil,nil,nil
    iterate do |x,y,color| 
      set_pixel(x,y,hsh[color]||color) 
    end
  end 
  def recolor *args,&block
    dup.recolor! *args,&block
  end
  def iterate_map 
    iterate { |x,y,color| set_pixel(x,y,yield(x,y,color)) }
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
  def iterate return_only=false 
    x, y = nil, nil
    for y in 0...height
      for x in 0...width
        yield x,y,get_pixel(x,y) 
      end
    end   
  end 
  def draw_line point1,point2,color,weight=1
    weight = weight.max(1).to_i
    x1,y1 = point1.to_a.map! &:to_i
    x2,y2 = point2.to_a.map! &:to_i
    # Bresenham's line algorithm
    a = (y2 - y1).abs
    b = (x2 - x1).abs
    s = (a > b)
    dx = (x2 < x1) ? -1 : 1
    dy = (y2 < y1) ? -1 : 1
    if s
      c = a
      a = b
      b = c
    end
    df1 = ((b - a) << 1)
    df2 = -(a << 1)
    d = b - (a << 1)
    set_pixel_weighted(x1, y1, color, weight) 
    if(s)
      while y1 != y2
        y1 += dy
        if d < 0
          x1 += dx
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    else
      while x1 != x2
        x1 += dx
        if d < 0
          y1 += dy
          d += df1
        else
          d += df2
        end
        set_pixel_weighted(x1, y1, color, weight) 
      end
    end 
  end
  def set_pixel_weighted x,y,color,weight=1
    even = ((weight % 2) == 0) ? 1 : 0
    half = weight / 2
    for px in (x-half)..(x+half-even)
      for py in (y-half)..(y+half-even)
        self.set_pixel(px, py, color) 
      end
    end
  end
end