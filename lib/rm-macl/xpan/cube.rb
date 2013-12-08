#
# rm-macl/lib/rm-macl/xpan/cube.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/surface'
module MACL #:nodoc:
  class Cube

    attr_reader :x, :y, :z, :width, :height, :depth

    # all attributes should be forced to an integer :D
    [:x, :y, :z, :width, :height, :depth].each do |key|
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

    def to_cube
      return MACL::Cube.new(@x, @y, @z, @width, @height, @depth)
    end

    def to_h
      return {
        x: @x, y: @y, z: @z,
        width: @width, height: @height, depth: @depth
      }
    end

    def to_s
      return "<#{self.class.name}: x%<x>d y%<y>d z%<z>d w%<width>d h%<height>d d%<depth>d>" % to_h
    end

    def empty
      @x, @y, @z = 0, 0, 0
      @width, @height, @depth = 0, 0, 0
      return self
    end

    def empty?
      return @width == 0 || @height == 0 || @depth == 0
    end

    tcast_set(Array)                   { |a| new(a[0], a[1], a[2], a[3], a[4], a[5]) }
    tcast_set(MACL::Mixin::Surface3)   { |s| new(s.x, s.y, s.z, s.width, s.height, s.depth) }
    tcast_set(self)                    { |s| new(s.x, s.y, s.z, s.width, s.height, s.depth) }
    tcast_set(:default)                { |d| d.to_cube }

    alias :initialize :set

  end
end
MACL.register('macl/xpan/cube', '1.3.0')