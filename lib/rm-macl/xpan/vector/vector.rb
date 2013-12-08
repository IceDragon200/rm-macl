#
# rm-macl/lib/rm-macl/xpan/vector/vector.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/math'
require 'rm-macl/core_ext/module'
require 'rm-macl/xpan/type-stub'
module MACL
  class Vector

    include Enumerable
    include Comparable

    attr_reader :data

    def initialize(size)
      @data = Array.new(size, 0)
    end

    def coerce(obj)
      return self, obj
    end

    def hash
      [self.class, @data].hash
    end

    def to_a
      @data.to_a
    end

    def size
      @data.size
    end

    def [](*args)
      @data[*args]
    end

    def []=(*args)
      @data.[]=(*args)
    end

    def _vector_enum_(obj, &block)
      to_enum(:_vector_enum_, obj) unless block_given?
      case obj
      when Numeric
        size.times { |i| yield obj, i }
      when Array, Vector
        if obj.size != size
          raise ArgumentError, "wrong #{obj.class}#size (expected #{size})"
        end
        obj.each_with_index(&block)
      else
        raise TypeError,
              "wrong argument type #{obj.class} (expected Numeric, Array or Vector)"
      end
      self
    end

    def each(&block)
      @data.each(&block)
    end

    def <=>(obj)
      @data <=> _vector_enum_(obj).to_a
    end

    def replace(other)
      _vector_enum_(other) { |x, i| @data[i] = x }
    end

    def add!(other)
      _vector_enum_(other) { |x, i| @data[i] += x }
    end

    def sub!(other)
      _vector_enum_(other) { |x, i| @data[i] -= x }
    end

    def mul!(other)
      _vector_enum_(other) { |x, i| @data[i] *= x }
    end

    def div!(other)
      _vector_enum_(other) { |x, i| @data[i] /= x }
    end

    def pow!(other)
      _vector_enum_(other) { |x, i| @data[i] **= x }
    end

    def root!(other)
      _vector_enum_(other) { |x, i| @data[i] = Math.rootn(@data[i], x) }
    end

    def affirm!
      @data.map!(&:+@); self
    end

    def negate!
      @data.map!(&:-@); self
    end

    def abs!
      @data.map!(&:abs); self
    end

    def add(other)
      dup.tap { |o| o.add!(other) }
    end

    def sub(other)
      dup.tap { |o| o.sub!(other) }
    end

    def mul(other)
      dup.tap { |o| o.mul!(other) }
    end

    def div(other)
      dup.tap { |o| o.div!(other) }
    end

    def pow(other)
      dup.tap { |o| o.pow!(other) }
    end

    def root(other)
      dup.tap { |o| o.root!(other) }
    end

    def affirm
      dup.tap { |o| o.affirm! }
    end

    def negate
      dup.tap { |o| o.negate! }
    end

    def abs
      dup.tap { |o| o.abs! }
    end

    def dot(other)
      @data.to_enum(:zip, _vector_enum_(other)).inject(0) { |r, (a, b)| r + a * b }
    end

    def magnitude
      Math.sqrt(@data.inject(0) { |r, x| r + x * x })
    end

    alias :+ :add
    alias :- :sub
    alias :* :mul
    alias :/ :div
    alias :** :pow

    alias :-@ :negate
    alias :+@ :affirm

    protected :data
    private :_vector_enum_

  end
end
MACL.register('macl/xpan/vector/vector', '2.0.0')