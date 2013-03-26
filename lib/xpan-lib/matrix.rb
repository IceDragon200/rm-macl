#
# RGSS3-MACL/lib/xpan-lib/matrix.rb
#   by IceDragon
#   dc 26/02/2013
#   dm 03/03/2013
# vr 0.9.1
module MACL
class Matrix

  class MatrixError < StandardError
  end

  attr_reader :dim, :datasize, :data

  ##
  # initialize(Array dimensions, Numeric default)
  def initialize(dimensions, default=0)
    @dim        = dimensions.size.to_i
    @dimensions = dimensions.map(&:to_i)
    @datasize   = @dimensions.dup.unshift(1).inject(:*)
    @default    = default
    @offsets    = []
    reset!
  end

  def dimensions
    return @dimensions.dup
  end

  def offsets
    return @offsets.dup
  end

  def dimnet
    return Array.new(@dimensions.size, 0), @dimensions.dup
  end

  ##
  # -@
  def -@
    matrix = dup
    matrix.data.map!(&:-@)
    return matrix
  end

  ##
  # +@
  def +@
    matrix = dup
    matrix.data.map!(&:+@)
    return matrix
  end

  ##
  # inc!
  def inc!
    data.each_with_index do |n, i|
      data[i] = n + 1
    end
    return self
  end

  ##
  # dec!
  def dec!
    data.each_with_index do |n, i|
      data[i] = n - 1
    end
    return self
  end

  ##
  # inc
  def inc
    return dup.inc!
  end

  ##
  # dec
  def dec
    return dup.dec!
  end

  ##
  # dispose
  def dispose
    @data = nil
  end

  ##
  # reset!
  def reset!
    dispose
    @data = Array.new(@datasize, @default)
    @offsets = (0...@dim).map { |i| @dimensions[0, i].unshift(1).inject(:*) }
    return nil
  end

  ##
  # dims_to_index(Numeric *dims) dims_to_index(x, y, z, n...)
  def dims_to_index(*dims)
    raise(ArgumentError,
      "Expected #{@dim+1} args but #{dims.size} given") unless @dim == dims.size
    n = 0
    @offsets.each_with_index { |o, i|
      return nil if dims[i] < 0 or !(dims[i] < @dimensions[i])
      n += dims[i] * o
    }
    return n #(n < @datasize) ? n : nil
  end

  def index_to_dims(index)
    return nil if index > datasize
    # TODO
    return dims
  end

  ##
  # dims_to_index(Numeric *dims) dims_to_index(x, y, z, n...)
  def [](*dims)
    return @default if dims.any? do |d| d < 0 end
    n = dims_to_index(*dims)
    return n ? @data[n] : @default
  end

  ##
  # dims_to_index(Numeric *args) dims_to_index(x, y, z, n..., value)
  def []=(*args)
    dims = args[0, args.size - 1]
    return nil if dims.any? do |d| d < 0 end
    n = dims_to_index(*dims)
    return unless n
    @data[n] = args[-1]
    return nil
  end

  ##
  # enum_recursion(Integer index, Array[Enumerable] enum_stack, Array[Object] args, &block)
  def enum_recursion(index, enum_stack, args, &block)
    enum_stack[index].each(&(
      if index < enum_stack.size-1
        proc { |n|
          enum_recursion(index + 1, enum_stack, args.dup.unshift(n), &block)
        }
      else
        proc { |n| yield args.dup.unshift(n) }
      end)
    )
  end

  # arithmetic with same size matrices
  [
    [    "add", "+", "%s"],
    [    "sub", "-", "%s"],
    [    "mul", "*", "%s"],
    [    "div", "/", "(%1$s == 0 ? 1 : %1$s)"],
    ["replace", "",  "%s"]
  ].each do |(word, sym, conv)|
    module_eval(%Q(
      def #{word}!(matrix)
        raise(ArgumentError,
          "Matrices must be the same dimensions, use #{word}_at instead"
        ) unless matrix.dimensions == @dimensions
        src_data = matrix.data
        for i in 0...@datasize
          num = src_data[i]
          @data[i] #{sym}= #{conv % 'num'}
        end
        return self
      end

      def #{word}_at!(trg_vec, matrix, src_vec_start, src_vec_end)
        raise(ArgumentError, "src_vec size mismatch") if src_vec_start.size != src_vec_end.size
        rngs = src_vec_start.zip(src_vec_end).map { |s, e| s...e }.reverse
        enum_recursion(0, rngs, []) do |nn|
          inds = Array.new(nn.size, 0)
          nn.each_with_index { |n, i|
            inds[i] = trg_vec[i] + n - src_vec_start[i]
          }
          num = matrix[*nn]
          self[*inds] #{sym}= #{conv % 'num'}
        end
        return self
      end

      def #{word}(*args)
        return dup.#{word}!(*args)
      end

      def #{word}_at(*args)
        return dup.#{word}_at!(*args)
      end
    ))
  end

  alias :+ :add
  alias :- :sub
  alias :* :mul
  alias :/ :div

  private :enum_recursion

end
end
