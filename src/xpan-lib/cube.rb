#
# src/xpan-lib/cube.rb
# vr 1.20
#
module MACL
  class Cube

    SYM_KEYS = [:x, :y, :z, :width, :height, :length]

    attr_accessor *SYM_KEYS

    def initialize(*args)
      _set(*args)
    end

    def hash
      [@x, @y, @z, @width, @height, @length].hash
    end

    def translate(x, y, z)
      @x, @y, @z = x, y, z
    end

    def resize(width, height, length)
      @width, @height, @length = width, height, length
    end

    def set(x=0, y=0, z=0, w=0, h=0, l=0)
      @x, @y, @z = x, y, z
      @width, @height, @length = w, h, l
    end

    alias :_set :set
    private :_set

    def hset(hash)
      valid_keys = hash.keys & SYM_KEYS
      valid_keys.each do |key|
        value = hash[key]
        instance_variable_set("@#{key.to_s}", value)
      end
      return self
    end

    def ary_from_keys(*keys)
      hsh = as_hash()
      return (keys & SYM_KEYS).collect { |sym| hsh[sym] }
    end

    alias xto_a ary_from_keys

    #def xto_a(keys)
    #  warn("Depreceated function call by #{caller[0..1]}")
    #  ary_from_keys(keys)
    #end

    def as_pos
      return MACL::Vector3.new(@x, @y, @z)
    end

    def as_ary
      return @x, @y, @z, @width, @height, @length
    end

    def as_rect
      Rect.new @x, @y, @width, @height
    end

    def as_hash
      return {
        x: @x, y: @y, z: @z,
        width: @width, height: @height, length: @length
      }
    end

    def to_s
      return "<#{self.class.name}: x%s y%s z%s w%s h%s l%s>" % to_a
    end

    def empty
      @x, @y, @z = 0, 0, 0
      @width, @height, @length = 0, 0, 0
      return self
    end

    #def area_wh
    #  @width * @height
    #end

    #def area_wl
    #  @width * @length
    #end

    #def area_hl
    #  @height * @length
    #end

    def volume
      @width * @height * @length
    end

  end
end

Cube = MACL::Cube
