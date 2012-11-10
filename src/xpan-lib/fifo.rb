#-// Fifo by IceDragon
#-// This is a limited size Array, which will always contain n elements.
#-// 16/06/2012 (DD/MM/YYYY)
#-// 16/06/2012 (DD/MM/YYYY)
#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Fifo', '0x10002'
#-end:
#-inject gen_class_header 'MACL::Fifo'
module MACL
  class Fifo

    include Enumerable

    def initialize size=1,defz=nil,&block
      @data = Array.new
      @default = defz
      resize! size, &block
    end

    def _clamp_range rng
      rng.first.max(0)..rng.last.min(@size)
    end

    def at *args
      raise(ArgumentError,'No Parameters given') if args.size == 0
      if args.size == 1
        n, = args
        if n.is_a? Numeric  ; return @data[n.to_i % @size]
        elsif n.is_a? Range ; return @data[_clamp_range(n)]
        end 
      else
        raise(ArgumentError,'All Parameters must be Numeric') unless args.all? {|i|i.is_a?(Numeric)}
        return args.collect{|i|@data[i.to_i % @size]}
      end
      @default  
    end

    alias :[] :at

    def sample
      @data.sample
    end

    def push_these *objs
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

    #private :push_these, :pull_these
    def replica
      result = Fifo.new 
      result.replace @data.clone
      result.default = @default
      result
    end

    alias clone replica
    alias dup replica

    def each &block
      @data.each &block
    end

    attr_accessor :default

    def + obj
      replica.push_these *obj.to_a
    end

    def - obj
      replica.pull_these @default,*obj.to_a
    end

    def * obj
      @data * obj
    end

    def push obj
      push_these *obj
    end

    alias :concat :+
    alias :<< :push

    def reject! &block
      self.patch(reject &block)
    end

    def select! &block
      self.patch(select &block)
    end

    def collect! &block
      self.patch(collect &block)
    end

    def size
      @size
    end

    def resize! new_size,elem=@default,&block
      @size = new_size.max(1)
      refresh elem,&block
    end

    def refresh elem=@default,&block
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

    private :refresh

    def resize *args,&block
      dup.resize! *args,&block
    end

    def to_a
      @data.dup
    end

    def to_hash
      Hash[to_a.each_with_index.to_a]
    end

    alias org_to_s to_s
    def to_s
      "<#{self.class.name}:%s>" % @data.inspect
    end

    def replace obj
      @data.replace obj.to_a
      self
    end

    def patch obj
      @data.replace obj.to_a
      refresh
    end

    alias org_hash hash
    def hash
      @data.hash
    end
    
  end
end
