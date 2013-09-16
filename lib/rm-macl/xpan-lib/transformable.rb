#
# RGSS3-MACL/lib/xpan-lib/transformable.rb
#
module MACL
  module Translatable

    ##
    # moves the object relative to its current position
    def move(nx, ny, nz=nil)
      self.x += nx
      self.y += ny
      self.z += nz if respond_to?(:z=) && nz
    end

    def set_position(nx, ny, nz=nil)
      self.x = nx
      self.y = ny
      self.z = nz if respond_to?(:z=) && nz
    end

    def get_position
      if respond_to?(:z)
        return self.x, self.y, self.z
      else
        return self.x, self.y
      end
    end

    alias :translate :move

  end

  module Scalable

    def scale(nx, ny, nz=nil)
      self.scale_x += nx
      self.scale_y += ny
      self.scale_z += nz if respond_to?(:scale_z=) && nz
    end

    def set_scale(nx, ny, nz=nil)
      self.scale_x = nx
      self.scale_y = ny
      self.scale_z = nz if respond_to?(:scale_z=) && nz
    end

    def get_scale
      if respond_to?(:scale_z)
        return self.scale_x, self.scale_y, self.scale_z
      else
        return self.scale_x, self.scale_y
      end
    end

  end

  module Rotatable

    def rotate(angle_x, angle_y=nil, angle_z=nil)
      if respond_to?(:angle=)
        self.angle += angle_x
      else
        self.angle_x += angle_x
        self.angle_y += angle_y
        self.angle_z += angle_z if respond_to?(:angle_z=) && angle_z
      end
    end

    def set_rotation(angle_x, angle_y=nil, angle_z=nil)
      if respond_to?(:angle=)
        self.angle = angle_x
      else
        self.angle_x = angle_x
        self.angle_y = angle_y
        self.angle_z = angle_z if respond_to?(:angle_z=) && angle_z
      end
    end

    def get_rotation
      if respond_to?(:angle)
        return self.angle
      else
        if respond_to?(:angle_z)
          return self.angle_x, self.angle_y, self.angle_z
        else
          return self.angle_x, self.angle_y
        end
      end
    end

  end

  module Origin

    def set_origin(nx, ny, nz)
      self.origin_x = nx
      self.origin_y = ny
      self.origin_z = nz if respond_to?(:origin_z) && nz
    end

    def get_origin
      if respond_to?(:origin_z)
        return self.origin_x, self.origin_y, self.origin_z
      else
        return self.origin_x, self.origin_y
      end
    end

  end

  module Transformable

    include Translatable
    include Scalable
    include Rotatable
    include Origin

    def to_transform
      Transform.new(get_position, get_rotation, get_scale)
    end

  end

  class Transform

    include Transformable

    def initialize(position, rotation, scale)
      @data = Array.new(3 * 3, 0.0)
      @data[0, 3] = Array(position).pad(3, 0.0)
      @data[3, 3] = Array(rotation).pad(3, 0.0)
      @data[6, 3] = Array(scale).pad(3, 0.0)
    end

    def x
      @data[0]
    end

    def y
      @data[1]
    end

    def z
      @data[2]
    end

    def angle_x
      @data[3]
    end

    def angle_y
      @data[4]
    end

    def angle_z
      @data[5]
    end

    def scale_x
      @data[6]
    end

    def scale_y
      @data[7]
    end

    def scale_z
      @data[8]
    end

    def x=(n)
      @data[0] = n
    end

    def y=(n)
      @data[1] = n
    end

    def z=(n)
      @data[2] = n
    end

    def angle_x=(n)
      @data[3] = n
    end

    def angle_y=(n)
      @data[4] = n
    end

    def angle_z=(n)
      @data[5] = n
    end

    def scale_x=(n)
      @data[6] = n
    end

    def scale_y=(n)
      @data[7] = n
    end

    def scale_z=(n)
      @data[8] = n
    end

    def get_position
      @data[0, 3]
    end

    def get_rotation
      @data[3, 3]
    end

    def get_scale
      @data[6, 3]
    end

    def [](x, y)
      return @data[x + y * 3]
    end

    def []=(x, y, n)
      @data[x + y * 3] = n
    end

    def translate(*args)
    end

    def rotate(angle, *args)
    end

    def scale(*args)
    end

    def self.convert(*args)
      case args.size
      when 1
        arg, = args
        case arg
        when Array
          case arg.size
          when 3 then return convert(*arg)
          when 9 then return convert(arg)
          else        raise ArgumentError, "expected Array of size 3 or 9"
          end
        when Transform
          return arg.to_transform
        else
          raise TypeError, "expected Array or Transform but recieved #{arg}"
        end
      when 3
        position, rotation, scale = args
        position = position.to_a
        rotation = rotation.to_a
        scale    = scale.to_a
        return new(position, rotation, scale)
      when 9
        position = args[0, 3]
        rotation = args[3, 3]
        scale    = args[6, 3]
        return new(position, rotation, scale)
      else
        raise ArgumentError, "expected 1, 3 or 9 args, but recieved #{args.size}"
      end
    end

  end
end
MACL.register('macl/xpan/transformable', '1.0.0')