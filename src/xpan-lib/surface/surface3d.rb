#
# src/xpan-lib/surface/surface3d.rb
# vr 1.00
class MACL::Surface3D < MACL::Surface

  attr_reader :z, :z2

  alias set2d set

  def set(*args)
    case args.size
    when 1
      surface = args[0]

      MACL::Mixin::Surface3D.type_check(surface)

      x, y, z, x2, y2, z2 = surface.as_s3a
    when 6
      x, y, z, x2, y2, z2 = *args
    else
      raise(ArgumentError, "expected 1 or 6 parameters but recieved #{args.size}")
    end
    @x, @y, @z, @x2, @y2, @z2 = x, y, z, x2, y2, z2
  end

  alias initialize set

  def z=(new_z)
    unless @freeform
      @z2 = new_z + depth
    end
    @z = new_z
  end

  def z2=(new_z2)
    unless @freeform
      @z = new_z2 - depth
    end
    @z2 = new_z2
  end

  def depth
    @z2 - @z
  end

  def depth=(new_depth)
    @z2 = @z + new_depth
  end

  def empty
    @x, @y, @z, @x2, @y2, @z2 = 0, 0, 0, 0, 0, 0
  end

  def to_s
    "<#{self.class.name} x: #{@x} y: #{@y} z: #{@z} x2: #{@x2} y2: #{@y2}> z2: #{@z2}"
  end

end
