#
# RGSS3-MACL/lib/xpan-lib/cube.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.29
module MACL
  class Cube

    sym_keys = [:x, :y, :z, :width, :height, :depth]

    attr_reader *sym_keys

    # all attributes should be forced to an integer :D
    sym_keys.each do |key|
      varname = "@#{key}"
      define_method("#{key}=") do |n|
        instance_variable_set(varname, n.to_i)
      end
    end

    def set(x=0, y=0, z=0, w=0, h=0, l=0)
      @x, @y, @z = x.to_i, y.to_i, z.to_i
      @width, @height, @depth = w.to_i, h.to_i, l.to_i
    end

    def hash
      [self.class, @x, @y, @z, @width, @height, @depth].hash
    end

    def translate(x, y, z)
      @x, @y, @z = x.to_i, y.to_i, z.to_i
    end

    def resize(width, height, depth)
      @width, @height, @depth = width.to_i, height.to_i, depth.to_i
    end

    def hset(hash)
      valid_keys = hash.keys & [:x, :y, :z, :width, :height, :depth]
      valid_keys.each do |key|
        value = hash[key]
        instance_variable_set("@#{key.to_s}", value)
      end
      return self
    end

    def to_a
      return [@x, @y, @z, @width, @height, @depth]
    end

    def to_rect
      return Rect.new(@x, @y, @width, @height)
    end

    def to_h
      return {
        x: @x, y: @y, z: @z,
        width: @width, height: @height, depth: @depth
      }
    end

    def to_s
      return "<#{self.class.name}: x%<x>d y%<y>d z%<z>d w%<width>d h%<height>d d%<depth>d>" % to_hash
    end

    def empty
      @x, @y, @z = 0, 0, 0
      @width, @height, @depth = 0, 0, 0
      return self
    end

    def empty?
      return @width == 0 || @height == 0 || @depth == 0
    end

    # since initialize does the same thing as set :D
    alias initialize set

  end
end
