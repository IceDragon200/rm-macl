#
# rm-macl/lib/rm-macl/xpan/matrix/matrix_base.rb
#
module MACL
  class MatrixBase

    include Comparable

    class MatrixError < StandardError
    end

    attr_reader :dim,      # Number of Dimensions present
                :datasize, # Datasize
                :data      # Data Array

    ##
    # initialize(Array<int> dimensions, Object default)
    def initialize(dimensions, default=0)
      @dim        = dimensions.size.to_i
      @dimensions = dimensions.map(&:to_i)
      @datasize   = @dimensions.dup.unshift(1).inject(:*)
      @default    = default
      @data       = nil
      @offsets    = []
      reset!
    end

    ##
    # dimensions
    def dimensions
      return @dimensions.dup
    end

    ##
    # offsets
    def offsets
      return @offsets.dup
    end

    ##
    # dimnet -> [[*floor], [*ceil]]
    def dimnet
      return Array.new(@dimensions.size, 0), @dimensions.dup
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
      @data = @default.is_a?(Proc) ? Array.new(@datasize, &@default) :
                                     Array.new(@datasize, @default)
      @offsets = (0...@dim).map { |i| @dimensions[0, i].unshift(1).inject(:*) }
      return nil
    end

    ##
    # dims_to_index(Numeric *dims) dims_to_index(x, y, z) -> int
    def dims_to_index(*dims)
      unless @dim == dims.size
        raise(ArgumentError, "Expected #{@dim} args but #{dims.size} given")
      end
      n = 0
      @offsets.each_with_index do |o, i|
        return nil if (dims[i] < 0 || !(dims[i] < @dimensions[i]))
        n += dims[i] * o
      end
      return n #(n < @datasize) ? n : nil
    end

    ##
    # index_to_dims(int index) -> Array<int>
    def index_to_dims(index)
      return nil if (index < 0 || index >= datasize)
      dims = []
      for i in 0...@dim
        n = index
        n /= @dimensions[0, i].inject(:*) if i > 0
        n %= @dimensions[i]
        dims << n
      end
      return dims
    end

    ##
    # get(Numeric *dims) get(x, y, z, n...) -> Numeric
    def get(*dims)
      return @default if dims.any? do |d| d < 0 end
      n = dims_to_index(*dims)
      return n ? @data[n] : @default
    end

    ##
    # set(Numeric *args) set(x, y, z, n..., value)
    def set(*args)
      dims = args[0, args.size - 1]
      unless dims.size == @dim
        raise(ArgumentError,
              "%d dimensions must be provided, %d was given" % [@dim, dims.size])
      end
      if n = dims_to_index(*dims)
        @data[n] = args[-1]
        after_set(n)
      end
      return nil
    end

    ##
    # enum_recursion(Integer index, Array<Enumerable> enum_stack, Array<Object> args, &block)
    def enum_recursion(index, enum_stack, args, &block)
      enum_stack[index].each(&(
        if index < (enum_stack.size - 1)
          ->(n) { enum_recursion(index + 1,
                                 enum_stack, args.dup.unshift(n), &block) }
        else
          ->(n) { block.(args.dup.unshift(n)) }
        end)
      )
    end

    ##
    # allowed_datatypes -> Array<Class>
    #   returns an Array of classes which are allowed by the Matrix as data
    def allowed_datatypes
      [Numeric]
    end

    ##
    # after_set(int index)
    #   callback function called after data has changed by Matrix calls
    def after_set(index)
      # do with data or some notification
    end

    ##
    # bang_do!(other) -> self
    #   abstract function for operating on all @data in the Matrix
    def bang_do!(other)
      case other
      when Matrix
        unless other.dimensions == @dimensions
          raise(ArgumentError,
                "Matrices must be the same dimensions, use #{word}_at instead")
        end
        other.data.each_with_index do |n, i|
          yield n, i
          after_set(i)
        end
      when *allowed_datatypes
        for i in 0...@datasize do
          yield other, i
          after_set(i)
        end
      else
        raise(self.class.make_type_error(other))
      end
      return self
    end

    ##
    # bang_at_do!(other) -> self
    #   abstract function for operating on a select @data in the Matrix
    def bang_at_do!(trg_vec, other, src_vec_start, src_vec_end)
      raise(ArgumentError,
            "src_vec size mismatch") if src_vec_start.size != src_vec_end.size
      case other
      when Matrix
        rngs = src_vec_start.zip(src_vec_end).map { |s, e| s...e }.reverse
        enum_recursion(0, rngs, []) do |nn|
          inds = Array.new(nn.size, 0)
          nn.each_with_index { |n, i|
            inds[i] = trg_vec[i] + n - src_vec_start[i]
          }
          num = other[*nn]
          yield num, *inds
        end
      when *allowed_datatypes
        rngs = src_vec_start.zip(src_vec_end).map { |s, e| s...e }.reverse
        enum_recursion(0, rngs, []) do |nn|
          inds = Array.new(nn.size, 0)
          nn.each_with_index { |n, i|
            inds[i] = trg_vec[i] + n - src_vec_start[i]
          }
          yield other, *inds
        end
      else
        raise(self.class.make_type_error(other))
      end
      return self
    end

    ##
    # replace!(Object other) -> self
    #   Replaces all the data in the Matrix with other
    #   if other is a Matrix then it will replace the data using the other's
    #   data
    def replace!(*args)
      bang_do!(*args) { |obj, i| @data[i] = obj }
    end

    ##
    # replace_at!(Array<int> trg_vec, Object other, Array<int> src_vec_start, Array<int> src_vec_end) -> self
    #   see replace!
    #   Operates on a select region of the Matrix starting at trg_vec
    def replace_at!(*args)
      bang_at_do!(*args) { |obj, *coords| set(*coords, obj) }
    end

    ##
    # replace(Object other) -> self
    #   see replace!
    def replace(*args)
      dup.replace!(*args)
    end

    ##
    # replace_at(Object other) -> self
    #   see replace_at!
    def replace_at(*args)
      dup.replace_at!(*args)
    end

    ##
    # to_a -> Array<Numeric>
    def to_a
      @data.dup
    end

    ##
    # <=>(Matrix other) -> int
    def <=>(other)
      self.to_a <=> other.to_a
    end

    ##
    # hash -> int
    def hash
      to_a.hash
    end

    ##
    # ::make_type_error(Object other) -> TypeError
    def self.make_type_error(other)
      err_msg = "Expected type %s or %s but recieved %s"
      err_msg %= [allowed_types.join(', '), self, other]
      TypeError.new(err_msg)
    end

    alias :size :datasize
    alias :[] :get
    alias :[]= :set

    private :enum_recursion, :bang_do!, :bang_at_do!, :allowed_datatypes, :after_set

  end
end
MACL.register('macl/xpan/matrix/base', '1.2.0')