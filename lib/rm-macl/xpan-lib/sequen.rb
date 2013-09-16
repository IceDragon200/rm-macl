#
# RGSS3-MACL/lib/xpan-lib/sequen.rb
#   by IceDragon
#   dc 04/19/2012
#   dc 03/03/2013
# vr 1.2.1
module MACL
  class Sequencer

    attr_accessor :maxcount, :index, :count
    attr_reader :sequence

    def initialize s, n=10
      self.sequence = s
      @index = 0
      @maxcount = n
      reset_count
    end

    def sequence= n
      n = n.to_a if n.is_a? Range
      @sequence = n
    end

    def reset_count
      @count = @maxcount
    end

    def value
      @sequence[@index]
    end

    def update
      @count = @count.pred.max 0
      if @count == 0
        @index = @index.succ.modulo @sequence.size
        @count = @maxcount
      end
    end

  end

  class Sequenex

    attr_accessor :list, :index, :reversed, :cycles, :cycle_index

    def initialize
      clear!
    end

    def add(obj)
      a = [obj.respond_to?(:done?),obj.respond_to?(:reset!),obj.respond_to?(:update)]
      unless a.all?
        err,name = NoMethodError, obj.class.name
        raise(err,'%s requires a "done?" method'  % name) unless a[0]
        raise(err,'%s requires a "reset!" method' % name) unless a[1]
        raise(err,'%s requires a "update" method' % name) unless a[2]
      end
      @list.push(obj)
    end

    def clear!
      @list     = []
      @index    = 0
      @reversed = false
      @cycles   = -1
      @cycle_index = 0
    end

    def reset!
      @index = 0
      @list.each(&:reset!)
    end

    def done?
      @list.all?(&:done?)
    end

    def reverse!
      @reversed = !@reversed
    end

    def current
      @list[@index]
    end

    def recycle!
      @cycle_index += 1
      return false if @cycle_index >= @cycles and !(@cycles == -1)
      on_cycle
      reset!
      return true
    end

    def on_cycle
    end

    def update
      return if @index >= @list.size
      n = current
      n.update

      if n.done?
        @index = (@reversed ? @index.pred : @index.succ)
        return unless recycle! if @index >= @list.size

        @index = @index.modulo(@list.size)

        n = current
        n.reset! if n
      end
    end

  end
end
