class Viewport 

  attr_accessor :z

  def initialize(x=0, y=0, width=544, height=416)
    @x, @y, @width, @height = x, y, width, height
    @z = 0
  end

end

class Sprite

  attr_accessor :z, :viewport

  def initialize(viewport=nil)
    @viewport = viewport
  end

  # Only for testing purposes
  def to_s
    "#{self.class} z: #{z}" + (viewport ? " viewport_z: #{viewport.z}" : "")
  end

end

# Jet Original
  def resort_sprite_z(array)
    array.sort! do |a, b|
      if !a.viewport.nil?
        if !b.viewport.nil?
          if a.viewport.z == b.viewport.z
            a.z <=> b.z
          end
        else
          a.viewport.z <=> b.z
        end
      elsif !b.viewport.nil?
        b.viewport.z <=> a.z
      else
        a.z <=> b.z
      end
    end
  end

  def resort_sprite_z2(array)
    # First group by viewports (initial z)
    viewports = {
      null: [] # For objects that don't have viewports
    }

    # iterate through the drawable objects (1st-time)
    array.each do |e|
      v = e.viewport || :null
      viewports[v] ||= [] # create array for this viewport if needed
      viewports[v].push(e) # this can be placed on the line above to save time
      # (viewports[v] ||= []).push(e) # Alternative to above
    end
    
  end

  ##
  # resort_sprite_z3(Array[IDrawable] array)
  #
  def resort_sprite_z3(array)
    # Hash<int z, Array[IDrawable]>
    zs = {}

    # Group objects by #z
    array.each do |e|
      z = (e.viewport || e).z
      (zs[z] ||= []).push(e) 
    end

    # Sort each value by elements z
    zs.values.each do |ary| 
      ary.sort! do |a, b| a.z <=> b.z end
      #ary.sort_by!(&:z) # 
    end

    result = []

    # Jam everything back into 1 array
    zs.keys.sort.each do |key|
      result.concat(zs[key])
    end

    return result
  end

objs = []

viewport1 = Viewport.new()
viewport2 = Viewport.new()
viewport3 = Viewport.new()
viewport2.z = 50
viewport3.z = 100

sp = Sprite.new()
sp.z = 25
objs.push(sp)

sp = Sprite.new(viewport1)
sp.z = 100
objs.push(sp)

sp = Sprite.new(viewport3)
sp.z = -100
objs.push(sp)

puts resort_sprite_z3(objs)
#class Array
#  def sort_by!(*args, &block); replace(sort_by(*args, &block)) ; end ; 
#end
