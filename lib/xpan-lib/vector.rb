#
# RGSS3-MACL/lib/xpan-lib/vector.rb
#   by IceDragon
#   dc 02/25/2013
#   dm 09/03/2013
# vr 1.4.1
module MACL

  # Parent class
  class Vector
  end

mk_vector_klass = proc do |class_name, conv_src, default_type, use_vec2_only_funcs=true, *arg_names|
  allset_src_spf = %Q(#{arg_names.map{ |a| "@#{a} %1$s= #{conv_src % "n#{a}"}" }.join("\n")})
  allset_src = allset_src_spf % ""

  vec2_src = if use_vec2_only_funcs
<<-VEC2_SRC
def self.polar(mag, radian)
  new(mag * Math.cos(radian), mag * Math.sin(radian))
end

def normalize!
  rad = radian
  self.x = Math.cos(rad)
  self.y = Math.sin(rad)
  self
end

def normalize
  return dup.normalize!
end

def magnitude
  return Math.sqrt(self.x * self.x + self.y * self.y)
end

def magnitude=(new_magnitude)
  rad = radian
  self.x = new_magnitude * Math.cos(rad)
  self.y = new_magnitude * Math.sin(rad)
end

def radian
  Math.atan2(self.y, self.x)
end

def radian=(new_radian)
  mag = magnitude
  self.x = mag * Math.cos(new_radian)
  self.y = mag * Math.sin(new_radian)
end

def angle
  return radian * PI180
end

def angle=(new_angle)
  self.radian = new_angle / PI180
end

def polar
  return magnitude, radian
end

def flipflop!
  @x, @y = @y, @x
  return self
end
VEC2_SRC
  else
    ""
  end

  cse_src = %Q( case arg
                when #{class_name}
                  #{arg_names.map{ |a| "n#{a}" }.join(?,)} = #{arg_names.map{ |a| "arg.#{a}" }.join(?,)}
                when Numeric
                  #{arg_names.map{ |a| "n#{a}" }.join(" = ")} = arg
                else
                  raise(TypeError, "Expected type #{class_name} or Numeric but recieved #{'#{arg.class}'}")
                end)

  arith_src = {add: :+, sub: :-, mul: :*, div: :/}.map do |(word, sym)|
    %Q(
      def #{word}!(arg)
        #{cse_src}
        #{allset_src_spf % sym.to_s}
        return self
      end

      def #{word}(arg)
        dup.#{word}!(arg)
      end

      alias #{sym} #{word}
    )
  end.join("\n")

  vector_src = <<VEC_END
class #{class_name} < Vector

  include Comparable

  PI180 = 180.0 / Math::PI

  def negate!
    #{arg_names.map{ |a| "@#{a} = -@#{a}" }.join(";")}
    return self
  end

  def -@
    return dup.negate!
  end

  def affirm!
    #{arg_names.map{ |a| "@#{a} = +@#{a}" }.join(";")}
    return self
  end

  def +@
    return dup.affirm!
  end

  #{vec2_src}

  attr_reader #{arg_names.map{|s|":#{s}"}.join(?,)}

  #{arg_names.map{|s|"def #{s}=(n); @#{s} = #{conv_src % "n"}; end"}.join("\n")}

  def self.from_cartesian(#{arg_names.join(?,)})
    return new(#{arg_names.join(?,)})
  end

  def self.Zero
    return new(#{Array.new(arg_names.size, default_type).join(?,)})
  end

  ##
  # set(Numeric x, Numeric y)
  # initialize(Numeric x, Numeric y)
  def set(*args)
    case args.size
    when 0
      #{arg_names.map{ |a| "n#{a}" }.join(?,)} = #{arg_names.map{ |a| default_type }.join(?,)}
    when 1
      arg, = args
      #{cse_src}
    when #{arg_names.size}
      #{arg_names.map{ |a| "n#{a}" }.join(?,)} = *args
    else
      raise(ArgumentError, "expected 0..#{arg_names.size} args but recieved #{'#{args.size}'}")
    end
    #{allset_src}
  end

  alias :initialize :set

  #{arith_src}

  def cartesian
    return #{arg_names.join(?,)}
  end

  def to_a
    return #{arg_names.join(?,)}
  end

  # Array Interfacing
  def size
    return #{arg_names.size}
  end

  alias :length :size

  def [](n)
    raise(ArgumentError, "Index out of range") if n >= size
    return to_a[n]
  end

  def []=(i, n)
    raise(ArgumentError, "Index out of range") if n >= size
    self.send(([#{arg_names.join(?,)}])[i].to_s + "=", n)
  end

end
VEC_END

  module_eval(vector_src)

  vector_src # return the vector src, just for exporting purposes
end

  mk_vector_klass.("Vector2f", "%s.to_f", 0.0, true, :x, :y)
  mk_vector_klass.("Vector3f", "%s.to_f", 0.0, true, :x, :y, :z)
  mk_vector_klass.("Vector4f", "%s.to_f", 0.0, true, :x, :y, :x2, :y2)
  mk_vector_klass.("Vector2i", "%s.to_i", 0, true, :x, :y)
  mk_vector_klass.("Vector3i", "%s.to_i", 0, true, :x, :y, :z)
  mk_vector_klass.("Vector4i", "%s.to_i", 0, true, :x, :y, :x2, :y2)

  mk_vector_klass = nil # drop make function

end
