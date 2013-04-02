#
# RGSS3-MACL/lib/xpan-lib/vector.rb
#   by IceDragon
#   dc 25/02/2013
#   dm 01/04/2013
# vr 1.5.0
module MACL
class Vector

  VERSION = "1.5.0".freeze

  include Comparable

  PI180 = 180.0 / Math::PI

  def <=>(other)
    self.to_a <=> other.to_a
  end

  def hash
    return to_a.hash
  end

  ##
  # Vector2 methods

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

  def cartesian
    return self.class.params_variables.map { |s| instance_variable_get(s) }
  end

  def do_set!(*args)
    params =
    if (args.size == 0)
      self.class.params.map { |s| send(s) }
    elsif (args.size == 1)
      other, = *args
      case other
      when Vector
        self.class.params.map do |mth|
          [mth, other.respond_to?(mth) ? other.send(mth) :
                                         self.class.default_value]
        end
      when Numeric
        Array.new(size) { |i| [self.class.params[i], other] }
      else
        raise(TypeError,
              "Expected type Vector or Numeric but recieved #{other.class}")
      end
    elsif (args.size == size)
      self.class.params.zip(args)
    else
      raise(TypeError, "Expected 0, 1 or #{size}")
    end

    if block_given?
      params.each { |(mth, val)| send(mth.to_s + "=", yield(mth, val)) }
    else
      params.each { |(mth, val)| send(mth.to_s + "=", val) }
    end
    self
  end

  def add!(*args)
    do_set!(*args) { |meth, v| send(meth) + v }
  end

  def sub!(*args)
    do_set!(*args) { |meth, v| send(meth) - v }
  end

  def mul!(*args)
    do_set!(*args) { |meth, v| send(meth) * v }
  end

  def div!(*args)
    do_set!(*args) { |meth, v| send(meth) / (v == 0 ? 1 : v) }
  end

  def add(*args)
    dup.add!(*args)
  end

  def sub(*args)
    dup.sub!(*args)
  end

  def mul(*args)
    dup.mul!(*args)
  end

  def div(*args)
    dup.div!(*args)
  end

  def set(*args)
    case args.size
    when 0    then do_set!(self.class.default_value)
    when 1    then do_set!(args[0])
    when size then do_set!(*args)
    end
    self
  end

  def size
    return self.class.params_size
  end

  def [](n)
    raise(ArgumentError, "Index out of range") if n < 0 || n >= size
    return to_a[n]
  end

  def []=(i, n)
    raise(ArgumentError, "Index out of range") if n < 0 || n >= size

  end

  def negate!
    do_set! { |_, n| -n }
    return self
  end

  def negate
    return dup.negate!
  end

  def affirm!
    do_set! { |_, n| +n }
    return self
  end

  def affirm
    return dup.affirm!
  end

  def self.polar(mag, radian)
    new(mag * Math.cos(radian), mag * Math.sin(radian))
  end

  def self.from_cartesian(*args)
    unless args.size == params_size
      raise(ArgumentError,
            "Expected #{params_size} but recieved #{args.size}")
    end
    new(*args)
  end

  def self.Zero
    new(default_value)
  end

  ##
  # class settings
  def self.params
    nil
  end

  def self.params_variables
    @params_variables ||= params.map { |s| "@" + s }.freeze
  end

  def self.params_map
    @params_map ||= params.zip(@params_variables).freeze
  end

  def self.params_size
    @params_size ||= params.size
  end

  def self.default_value
    0
  end

  def self.convert_param(param)
    param
  end

  def self.make_attr(param)
    attr_reader(param)
    var = "@%s" % param
    define_method(param.to_s + "=") do |n|
      instance_variable_set(var, self.class.convert_param(n))
    end
  end

  alias :to_a :cartesian
  alias :length :size
  alias :initialize :set

  alias :+ :add
  alias :- :sub
  alias :* :mul
  alias :/ :div

  alias :-@ :negate
  alias :+@ :affirm

  private :do_set!

end
end
