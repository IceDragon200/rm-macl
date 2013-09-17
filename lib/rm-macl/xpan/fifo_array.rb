#
# rm-macl/lib/rm-macl/xpan/fifo_array.rb
#
require 'rm-macl/macl-core'
module MACL
  class FifoArray

    include Enumerable
    include Comparable

    attr_accessor :default

    def initialize(size=1, defz=nil, &block)
      @data = Array.new
      @default = defz
      resize!(size, &block)
    end

    def _clamp_range(rng)
      rng.first.max(0)..rng.last.min(@size)
    end

    def at(*args)
      raise(ArgumentError,'No Parameters given') if args.size == 0
      if args.size == 1
        n, = args
        if n.is_a? Numeric  ; return @data[n.to_i % @size]
        elsif n.is_a? Range ; return @data[_clamp_range(n)]
        end
      else
        raise(ArgumentError, 'All Parameters must be Numeric') unless args.all? {|i|i.is_a?(Numeric)}
        return args.map { |i| @data[i.to_i % @size] }
      end
      @default
    end

    def sample
      @data.sample
    end

    def push_these(*objs)
      for obj in objs do @data.offset obj end
      self
    end

    def pull_these replacement=@default,*objs
      unless block_given?
        @data.each_with_index do |n,i|
          @data[i] = replacement if objs.include? n
        end
      else
        @data.each_with_index do |n,i|
          @data[i] = yield i if objs.include? n
        end
      end
      self
    end

    def replica
      result = Fifo.new
      result.replace(@data)
      result.default = @default
      result
    end

    def each &block
      @data.each &block
    end

    def +(obj)
      replica.push_these *obj.to_a
    end

    def -(obj)
      replica.pull_these @default,*obj.to_a
    end

    def *(obj)
      @data * obj
    end

    def push(obj)
      push_these *obj
    end

    def reject!(&block)
      self.patch(reject &block)
    end

    def select!(&block)
      self.patch(select &block)
    end

    def map!(&block)
      self.patch(map(&block))
    end

    def size
      @size
    end

    def resize!(new_size, elem=@default, &block)
      @size = new_size.max(1)
      refresh elem,&block
    end

    def refresh(elem=@default, &block)
      if @data.size < @size
        count = 0
        if block_given?
          until @data.size == @size
            @data.push(yield count)
            count += 1
          end
        else
          @data.push elem until @data.size == @size
        end
      elsif @data.size > @size
        @data.shift until @data.size == @size
      end
      self
    end

    def resize(*args, &block)
      dup.resize! *args,&block
    end

    def to_a
      @data.dup
    end

    def to_h
      Hash[to_a.each_with_index.to_a]
    end

    def to_s
      "<#{self.class.name}: %s>" % @data.inspect
    end

    def replace(obj)
      @data.replace(obj.to_a)
      self
    end

    def patch(obj)
      @data.replace(obj.to_a)
      refresh
    end

    def <=>(obj)
      obj.data <=> @data
    end

    alias :[] :at
    alias clone replica
    alias dup replica
    alias :concat :+
    alias :<< :push

    private :refresh

  end
end
MACL.register('macl/xpan/fifo_array', '1.2.0')