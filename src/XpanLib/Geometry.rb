#-// 16/07/2012
#-// 16/07/2012
#-apndmacro _imported_
#-inject gen_scr_imported 'Geometry', '0x10001'
#-end:
#-inject gen_module_header 'Geometry'
module Geometry
#-inject gen_class_header 'Path'  
  class Path
    attr_accessor :points
    def initialize *args
      @points = args.collect do |a| 
        a.is_a?(Enumerable) ? Point.new(*a[0,1]) : a
      end
    end
    def lerp rate=1.0
      cindex = ((@points.size - 1) * rate.to_f).floor 
      nindex = (cindex + 1).min(@points.size)
      x1,y1  = @points[cindex].to_a
      x2,y2  = @points[nindex].to_a
      return [x1 + (x2 - x1) * rate, y1 + (y2 - y1) * rate]
    end
  end
#-inject gen_class_header 'Line'      
  class Line < Path
    def initialize p1,p2
      super p1,p2
    end
  end
#-inject gen_class_header 'Angle'    
  class Angle < Path
    attr_accessor :parent_index
    def initialize p1,p2,p3
      super p1,p2,p3
      @parent_index = 1
    end
    def parent_point
      @points[@parent_point]
    end
    def angle
    end
  end
#-inject gen_class_header 'Oval'    
  class Oval
    include MACL::Mixin::Surface
    attr_accessor :cx,:cy
    attr_accessor :radius_x,:radius_y
    attr_accessor :angle_offset
    def initialize( x=0, y=0, radius_x=0, radius_y=0 )
      @cx, @cy, @radius_x, @radius_y = x, y, radius_x, radius_y 
      @angle_offset = 0
    end
    def x
      cx - radius_x
    end  
    def y
      cy - radius_y
    end
    def x= n 
      self.cx = n + radius_x
    end
    def y= n 
      self.cy = n + radius_y
    end  
    def width
      @radius_x * 2
    end
    def height
      @radius_y * 2
    end  
    def width= n 
      @radius_x = n / 2
    end  
    def height= n 
      @radius_y = n / 2
    end  
    def diameter_x
      @radius_x * 2
    end 
    def diameter_y
      @radius_y * 2
    end 
    def calc_xy_from_angle angle 
      opangle = Math::PI * (angle - @angle_offset) / 180.0
      return @cx + @radius_x * Math.cos(opangle), @cy + @radius_y * Math.sin(opangle)
    end    
    def calc_angle x2, y2 
      dx, dy = x2 - @cx, y2 - @cy
      m = dx.abs.max(dy.abs).max(1).to_f
      180 + (Math.atan2((dy)/m, (dx)/m) / Math::PI) * -180 rescue 0
    end
    def calc_circ_dist x2, y2 
      dx, dy = @cx - x2, @cy - y2
      m = dx.abs.max(dy.abs).max(1).to_f
      (dx * Math.cos(Math::PI * dx / m)).abs + (dy * Math.cos(Math::PI * dy / m)).abs
    end  
    def in_circ_area? x, y 
      calc_circ_dist(x,y).abs <= calc_circ_dist(*get_angle_xy(calc_angle(x,y))).abs
    end 
    def set *args 
      if args[0].is_a?(Oval)
        o = args[0]
        self.x, self.y, self.radius_x, self.radius_y = o.x, o.y, o.rdx, o.rdy
      else  
        self.x, self.y = args[0] || self.x, args[1] || self.y
        self.radius_x, self.radius_y = args[2] || self.rdx, args[3] || self.rdy
      end
      self
    end  
    def empty
      set 0, 0, 0, 0 
    end  
    def cyc_360_angle(n=0,clockwise=true)
      clockwise ? n.next.modulo(360) : n.pred.modulo(360)
    end  
    def cycle_360(n=nil,clockwise=true)
      i = 0
      if n
        n.times { |c| yield i, c ; i = cyc_360_angle(i,clockwise) }
      else
        loop do 
          yield i ; i = cyc_360_angle(i,clockwise)
        end  
      end
    end
    def circumfrence
      2 * Math::PI * ((radius_x + radius_y) / 2)
    end  
  end  
#-inject gen_class_header 'Circle'  
  class Circle < Oval
    attr_reader :radius
    def initialize( x=0, y=0, radius=0 )
      super( x, y, 0, 0 )
      self.radius = radius 
    end 
    def diameter
      @radius * 2
    end  
    def radius=( n )
      self.radius_x = self.radius_y = @radius = n
    end
    def set( *args )
      args.push(args[2]) if args.size == 3
      super( *args )
    end
  end
#-inject gen_class_header 'Polygon'    
  class Polygon < Oval
    attr_accessor :sides
    def initialize sides, x=0, y=0, w=0, h=0 
      super x, y, w, h 
      @sides = sides
      @angle_offset = 180
    end  
    def side_angle_size
      360.0 / @sides
    end  
    def get_side_xy1(side=0) # // Exact Point
      get_angle_xy(side_angle_size*side)
    end  
    def get_side_xy2(side=0, n=1) # // Line Point
      get_angle_xy((side_angle_size*side)+(side_angle_size/2*n))
    end 
    alias :get_side_xy :get_side_xy1
    def next_side(n=0)
      n.next.modulo(@sides)
    end  
    def prev_side(n=0)
      n.pred.modulo(@sides)
    end 
    def cyc_side(n=0,aclockwise=false)
      aclockwise ? next_side(n) : prev_side(n)
    end  
    def cycle_sides(start_side=0, aclockwise=false, n=nil)
      i = start_side
      if n
        n.times { |c| yield i, c ; i = cyc_side(i,aclockwise) }
      else
        loop do 
          yield i ; i = cyc_side(i,aclockwise)
        end  
      end  
    end 
  end  
end