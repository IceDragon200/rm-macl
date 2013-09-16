#
# RGSS3-MACL/lib/xpan-lib/tween/tween.rb
#   by IceDragon
#   dc ??/??/2011
#   dc 03/03/2013
# vr 1.1.2
require File.join(File.dirname(__FILE__), 'tweenerror')

module MACL
class Tween

  class << self

    def init
      @@sec_per_frame = 1.0 / MACL.frame_rate
    end

    def sec_per_frame
      @@sec_per_frame
    end

    def frame_to_sec(frames)
      Float(frames * @@sec_per_frame)
    end

    def sec_to_frame(sec)
      Integer(sec * MACL.frame_rate)
    end

  end

  attr_reader :values
  attr_accessor :start_values, :end_values
  attr_reader :time, :timemax
  attr_accessor :delta # by default delta is the seconds per frame
  attr_reader :easer_sym

  def initialize(*args, &block)
    @delta = @@sec_per_frame
    set_and_reset(*args, &block)
  end

  def change_time val=nil,max=nil
    @time    = val if val
    @timemax = max if max
  end

  def value index=0
    return @values[index]
  end

  # // Legacy support
  def set(*args)
    if (hash, = args).is_a?(Hash)
      start_values = hash[:start_values]
      end_values   = hash[:end_values]
      easer        = hash[:easer]
      timemax      = hash[:timemax]
      extra_params = hash[:extra_params]
    else
      start_values, end_values, easer, timemax, extra_params = *args
    end
    start_values ||= [0]
    end_values ||= [0]
    easer ||= :linear
    timemax ||= 1.0
    extra_params ||= []
    unless MACL::Easer.has_easer?(easer)
      raise(TweenError, 'Invalid easer type: %s' % easer.to_s)
    end
    start_values = start_values
    end_values   = end_values
    @start_values, @end_values = start_values, end_values
    @easer_sym, @timemax = easer, timemax
    @easer = MACL::Easer.get_easer(@easer_sym)
    @extra_params = extra_params
    scale_values(1.0) # forces all values to Floats
    @values = []
    update_value @time
  end

  def set_and_reset(*args)
    reset_time
    set(*args)
  end

  def scale_values(n=1.0)
    @start_values = @start_values.map { |v| v * n }
    @end_values   = @end_values.map { |v| v * n }
  end

  def change_easer new_easer
    @easer_sym = new_easer
  end

  def reset_time
    @time = 0.0
  end

  def reset!
    reset_time
    update_value_now
  end

  def easer
    return @easer
  end # // YAY now u can dump it >_>

  def done?
    @time >= @timemax
  end # // Time gets capped anyway

  def pred_time
    @time = (@time - @delta).max(0)
  end

  def succ_time
    @time = (@time + @delta).min(@timemax)
  end

  def time_rate
    time_to_rate(@time)
  end

  def time_to_rate(t=@time)
    t / @timemax
  end

  def value_at_time(t, sv=@start_values[0], ev=@end_values[0])
    easer.ease(t, sv, ev, @timemax, *@extra_params)
  end

  def invert
    @start_values, @end_values = @end_values, @start_values
    return self
  end

  def update_until_done
    yield self while update && !done?
    return self
  end

  def update
    succ_time unless done? # // Save a little cpu..
    update_value_now if time_changed?
  end

  def update_value_now
    update_value(@time)
  end

  def update_value(t)
    for i in 0...@start_values.size
      @values[i] = value_at_time(t, @start_values[i], @end_values[i])
    end
    self
  end

  def to_enum
    return Enumerator.new do |yielder|
      tween = self.clone
      tween.reset_time
      tween.update_until_done(&yielder.method(:yield))
    end
  end

private

  def time_changed?
    if @time != @last_time
      @last_time = @time
      return true
    end
    return false
  end

end
end
