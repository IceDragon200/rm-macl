#-inject gen_module_header 'MACL::Morph'
#-inject gen_scr_imported_ww 'MACL::Morph', '0x10000'
module MACL::Morph
#-inject gen_class_header 'Growth'
#-// 12/14/2011
#-// 12/21/2011
#-// Version : 1.0
  class Growth
    attr_reader :nodes
    attr_reader :open_nodes
    NODE_DIRECTIONS = [
      [ 0,  0],
      [ 0,  1], # // Down
      [-1,  0], # // Left
      [ 1,  0], # // Right
      [ 0, -1], # // Up
    ]
    attr_accessor :same_dir_rate
    attr_accessor :node_thinning
    def initialize
      @nodes = []
      @open_nodes = [[0, 0, 0]]
      @same_dir_rate = 35 
      @node_thinning = 2
      #@ntable = Table.new( *table_size )
    end 
    def ntable_at( x, y )
      @ntable[x % @ntable.xsize, y % @ntable.ysize]
    end  
    def ntable_set_at( x, y, value )
      @ntable[x % @ntable.xsize, y % @ntable.ysize] = value
    end 
    def table_size
      return 100*2, 100*2
    end  
    def grow_by( n ) 
      n.times { grow() } 
      return self 
    end
    def grow()
      new_open_nodes = []
      @nodes |= @open_nodes.collect do |c|
        node_count = [c[2] == 0 ? 4 : (3 - (c[0].abs+c[1].abs) / @node_thinning), 0].max
        node_count.times do
          new_open_nodes << random_node( c[0], c[1], c[2] )
          #n = random_node( c[0], c[1], c[2] )
          #if ntable_at(n[0], n[1]) == 0
            #new_open_nodes << n ; ntable_set_at(n[0], n[1], 1)
          #end  
        end
        c
      end
      @open_nodes = new_open_nodes
      return self
    end  
    def final_nodes
      return (@nodes + @open_nodes).uniq
    end  
    def random_node( x, y, from_direction )
      possible_routes = [1, 2, 3, 4] - [5-from_direction]
      if seed_rand(100) < @same_dir_rate 
        dir = from_direction
      else  
        dir = possible_routes[seed_rand(possible_routes.size)]
      end
      nx, ny = *NODE_DIRECTIONS[dir]
      #rx, ry = nx + x, ny + y      
      #return rx, ry, dir
      return nx + x, ny + y, dir
    end 
    def seed_rand( arg )
      seed_gen.nil?() ? rand( arg ) : seed_gen.rand( arg )
    end  
    attr_reader :seed_gen
    def set_seed_gen( seed )
      @seed_gen = Random.new( seed )
      return self
    end  
  end  
#-inject gen_class_header 'Devour'
#-// 12/15/2011
#-// 12/21/2011
#-// Version : 1.0
  class Devour
    def initialize( nodes )
      @growth = Growth.new()
      @devoured = []
      @nodes = nodes
      @x, @y = 0, 0
    end  
    def set_pos( x, y ) 
      @x, @y = x, y
      self
    end  
    def devour_by( n )
      n.times { devour() }
      self
    end  
    def devour
      new_nodes = @growth.grow().open_nodes.collect { |nd| [nd[0]+@x, nd[1]+@y] }
      @devoured |= new_nodes & @nodes
      self
    end  
    def final_nodes()
      return @nodes - @devoured
    end 
    def seed_gen()
      return @growth.seed_gen
    end  
    def set_seed_gen( seed )
      @growth.set_seed_gen( seed )
      return self
    end
  end  
#-inject gen_class_header 'Decimate'
#-// 12/15/2011
#-// 12/21/2011
#-// Version : 1.0
  class Decimate
    def initialize( nodes )
      @decimated = []
      @nodes = nodes
    end 
    def decimate_by( n )
      n.times { decimate() }
      self
    end  
    def decimate
      nds = final_nodes
      @decimated << nds[seed_rand(nds.size)] unless nds.empty?
      self
    end  
    def final_nodes()
      return @nodes - @decimated
    end 
    def seed_rand( arg )
      seed_gen.nil?() ? rand( arg ) : seed_gen.rand( arg )
    end  
    attr_reader :seed_gen
    def set_seed_gen( seed )
      @seed_gen = Random.new( seed )
      return self
    end 
  end 
end