#
# rm-macl/lib/rm-macl/xpan/tween2.rb
#   by IceDragon
# CHANGELOG
#     vr 1.1.0
#       added #source(index) and #target(index)
require 'rm-macl/macl-core'
require 'rm-macl/xpan/convert'
require 'rm-macl/xpan/easer'
module MACL #:nodoc:
  class Tween2

    attr_reader :pairs, :ticksmax, :easer, :result
    attr_reader :start_values, :end_values # Legacy Tween interfacing
    attr_accessor :tick, :tickdelta

    ##
    # initialize(int tickmax, Easer easer, Array<Array<Numeric>[2]> pairs)
    # initialize(int tickmax, Symbol easer, Array<Array<Numeric>[2]> pairs)
    #   easer is expected to be either a Symbol or a MACL::Easer
    def initialize(ticksmax, easer, *pairs)
      init_members
      setup(ticksmax, easer, *pairs)
      refresh_result
    end

    ##
    # init_members
    def init_members
      @ticksdelta = 1
      @ticks    = 0
      @ticksmax = 1
      @easer   = nil
      @result  = nil
      @pairs   = nil

      @start_values = nil
      @end_values = nil
    end

    ##
    # setup(int tickmax, Easer easer, Array<Array<Numeric>[2]> pairs)
    # setup(int tickmax, Symbol easer, Array<Array<Numeric>[2]> pairs)
    def setup(tickmax, easer, *pairs)
      setup_tick(tickmax)
      setup_easer(easer)
      setup_pairs(*pairs)
    end

    ##
    # setup_tick(int tickmax)
    def setup_tick(tickmax)
      @ticksmax = tickmax.to_i
    end

    ##
    # setup_easer(Object obj)
    def setup_easer(obj)
      @easer = MACL::Convert.Easer(obj)
    end

    ##
    # setup_pairs(Hash<Numeric, Numeric> pairs)
    def setup_pairs(*pairs)
      #raise(ArgumentError, "Bad pair in pairs") if pairs.any? { |a| a.size != 2 }
      @pairs = pairs.map { |a| a.map(&:to_f) }.freeze
      refresh_values
    end

    def refresh_values
      @start_values = @pairs.map(&:first).freeze
      @end_values   = @pairs.map(&:last).freeze
    end

    def update_tick
      if active?
        @ticks = [[@ticks + @ticksdelta, 0].max, @ticksmax].min
      end
    end

    def update_result
      t = @ticks / @ticksmax.to_f
      @pairs.each_with_index do |(alpha, zeta), i|
        @result[i] = @easer.ease(t, alpha, zeta, 1.0)
      end
    end

    def update
      update_tick and update_result
    end

    def refresh_result
      @result = Array.new(@pairs.size, nil)
      update_result
    end

    def reset_tick
      @ticks = @ticksdelta > 0 ? 0 : @ticksmax
    end

    def active?
      return @ticksdelta > 0 ? (@ticks < @ticksmax) : (@ticks > 0)
    end

    def to_a
      ary = []
      old_ticks = @ticks
      reset_tick
      update_result
      (ary << result; update) until !active?
      @ticks = old_ticks
      update_result
      return ary
    end

    ### helpers
    def source(index=0)
      @pairs[index][0]
    end

    def target(index=0)
      @pairs[index][1]
    end

    ### Tween 1 Interfacing
    def value(index=0)
      @result[index]
    end

    def values
      return @result
    end

    private :init_members, :update_result

  end
end
MACL.register('macl/xpan/tween2', '1.2.0')