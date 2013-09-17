#
# rm-macl/lib/rm-macl/xpan/vector/vector.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/xpan/vector/abstract/vector2'
require 'rm-macl/xpan/vector/abstract/vector3'
require 'rm-macl/xpan/vector/abstract/vector4'

module MACL
  class Vector

    include Comparable

    PI180 = 180.0 / Math::PI

    def <=>(other)
      self.to_a <=> other.to_a
    end

    def hash
      return to_a.hash
    end

    def vec_params(*args)
      if (args.size == 0)
        return self.class.params.map { |s| send(s) }
      elsif (args.size == 1)
        other, = *args
        case other
        when Vector
          return self.class.params.map do |mth|
            [mth, other.respond_to?(mth) ? other.send(mth) :
                                           self.class.default_value]
          end
        when Numeric
          return self.class.params.zip([other] * size)
        when Array
          raise(ArgumentError,
                "Expected array of size #{size}") unless other.size == size
          return self.class.params.zip(other)
        else
          raise(TypeError,
                "Expected type Vector or Numeric but recieved #{other.class}")
        end
      elsif (args.size == size)
        return self.class.params.zip(args)
      else
        raise(ArgumentError, "Expected 0, 1 or #{size}")
      end
    end

    def do_set!(*args)
      params = vec_params(*args)

      if block_given?
        params.each { |(mth, val)| send(mth.to_s + "=", yield(mth, val)) }
      else
        params.each { |(mth, val)| send(mth.to_s + "=", val) }
      end
      self
    end

    def do_set(*args)
      dup.do_set!(*args)
    end

    def add!(*args)
      raise(ArgumentError,
            "Expected 1 or more but recieved #{args.size}") unless args.size > 0
      do_set!(*args) { |meth, v| send(meth) + v }
    end

    def sub!(*args)
      raise(ArgumentError,
            "Expected 1 or more but recieved #{args.size}") unless args.size > 0
      do_set!(*args) { |meth, v| send(meth) - v }
    end

    def mul!(*args)
      raise(ArgumentError,
            "Expected 1 or more but recieved #{args.size}") unless args.size > 0
      do_set!(*args) { |meth, v| send(meth) * v }
    end

    def div!(*args)
      raise(ArgumentError,
            "Expected 1 or more but recieved #{args.size}") unless args.size > 0
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

    ##
    # set()
    # set(Vector vec)
    # set(Numeric n)
    # set(..n)
    def set(*args)
      case args.size
      when 0    then do_set!(self.class.default_value)
      when 1    then do_set!(args.first)
      when size then do_set!(*args)
      end
      self
    end

    ##
    # size -> Integer
    def size
      return self.class.params_size
    end

    ##
    # dot -> Numeric
    #   Dot product of 2 vectors
    def dot(*args)
      params = vec_params(*args)
      return params[0, size].zip(to_a).inject(0) { |r, (a, b)| r + a * b }
    end

    ##
    # [](int i) -> Numeric
    def [](i)
      raise(ArgumentError, "Index out of range") if i < 0 || i >= size
      return to_a[i]
    end

    ##
    # []=(int index, Numeric n)
    def []=(i, n)
      raise(ArgumentError, "Index out of range") if n < 0 || n >= size
      send(self.class.params[i].to_s + "=", n)
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

    def abs!
      self.class.params.each do |sym|
        send(sym.to_s + "=", send(sym).abs)
      end
      self
    end

    def abs
      dup.abs!
    end

    ##
    # to_a -> Array<Numeric>
    def to_a
      return self.class.params_variables.map { |s| instance_variable_get(s) }
    end

    ##
    # zero?
    def zero?
      to_a.all?(&:zero?)
    end

    ##
    # smooth_step(Vector other)
    def smooth_step(other, delta=0.0)
      do_set(other) { |meth, v| send(meth) + (v - send(meth)) * delta }
    end

    def self.polar(mag, radian)
      new(mag * Math.cos(radian), mag * Math.sin(radian))
    end

    def self.cartesian(*args)
      unless args.size == params_size
        raise(ArgumentError,
              "Expected #{params_size} but recieved #{args.size}")
      end
      new(*args)
    end

    ##
    # ::zero -> Vector
    def self.zero
      new(default_value)
    end

    ##
    # ::one -> Vector
    def self.one
      new(1)
    end

    ###
    # class settings

    ##
    # ::params
    def self.params
      raise(RuntimeError, "Params have not been defined for #{self}")
    end

    ##
    # ::params_variables
    def self.params_variables
      @params_variables ||= params.map { |s| "@" + s.to_s }.freeze
    end

    ##
    # ::params_map
    def self.params_map
      @params_map ||= params.zip(@params_variables).freeze
    end

    ##
    # ::params_size
    def self.params_size
      @params_size ||= params.size
    end

    ##
    # ::default_value
    def self.default_value
      0
    end

    ##
    # ::convert_param
    def self.convert_param(param)
      param
    end

    ##
    # ::make_attr
    def self.make_param_attr(param)
      attr_reader(param)
      var = "@%s" % param
      define_method(param.to_s + "=") do |n|
        instance_variable_set(var, self.class.convert_param(n))
      end
    end

    ##
    # ::make_param_attrs
    def self.make_param_attrs
      params.each { |s| make_param_attr(s) }
    end

    ###
    # aliases
    alias :cartesian :to_a
    alias :length :size
    alias :initialize :set

    alias :+ :add
    alias :- :sub
    alias :* :mul
    alias :/ :div

    alias :-@ :negate
    alias :+@ :affirm

    ###
    # visibility
    private :do_set!
    private :vec_params

    class << self
      private :make_param_attr, :make_param_attrs
    end

  end
end
MACL.register('macl/xpan/vector/vector', '1.6.0')