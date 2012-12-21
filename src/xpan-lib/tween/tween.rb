#
# src/xpan-lib/tween/tween.rb
#
# vr 1.11
module MACL
class Tween

  attr_reader :values, :start_values, :end_values
  attr_reader :time, :maxtime

  class << self

    def init
      @@sec_per_frame = 1.0 / Graphics.frame_rate
    end

    def sec_per_frame
      @@sec_per_frame
    end

    def frame_to_sec(frames)
      Float(frames * @@sec_per_frame)
    end

    def sec_to_frame(sec)
      Integer(sec * Graphics.frame_rate)
    end

  end

  def initialize *args,&block
    set_and_reset *args,&block
  end

  def change_time val=nil,max=nil
    @time    = val if val
    @maxtime = max if max
  end

  def value index=0
    return @values[index]
  end

  # // Legacy support
  def set *args
    if (hash, = args).is_a?(Hash)
      start_values = hash[:start_values]
      end_values   = hash[:end_values]
      easer        = hash[:easer]
      maxtime      = hash[:maxtime]
      extra_params = hash[:extra_params]
    else
      start_values, end_values, easer, maxtime, extra_params = *args
    end
    start_values ||= [0]
    end_values ||= [0]
    easer ||= :linear
    maxtime ||= 1.0
    extra_params ||= []
    raise(TweenError,'Invalid easer type: %s' % easer.to_s) unless Tween::EASER_BY_SYMBOL.has_key? easer
    start_values = Array(start_values)
    end_values   = Array(end_values)
    @start_values, @end_values = start_values, end_values
    @easer, @maxtime = easer, maxtime
    @extra_params = extra_params
    scale_values
    @values = []
    update_value @time
  end

  def set_and_reset *args
    reset_time
    set *args
  end

  def scale_values n=1.0
    @start_values = @start_values.collect { |v| v * n }
    @end_values   = @end_values.collect { |v| v * n }
  end

  def change_easer new_easer
    @easer = new_easer
  end

  def reset_time
    @time = 0.0
  end

  def reset!
    reset_time
    update_value_now
  end

  def easer
    return Tween::EASER_BY_SYMBOL[@easer]
  end # // YAY now u can dump it >_>

  def done?
    @time == @maxtime
  end # // Time gets capped anyway

  def pred_time
    @time = (@time- @@sec_per_frame).max 0
  end

  def succ_time
    @time = (@time+@@sec_per_frame).min @maxtime
  end

  def time_rate
    time_to_rate @time
  end

  def time_to_rate t=@time
    t / @maxtime
  end

  def value_at_time time, sv=@start_values[0], ev=@end_values[0]
    easer.ease time, sv, ev, @maxtime, *@extra_params
  end

  def invert
    @start_values, @end_values = @end_values, @start_values
    self
  end

  def update_until_done
    yield self while update && !done?
    self
  end

  def update
    succ_time unless done? # // Save a little cpu..
    update_value_now
  end

  def update_value_now
    update_value @time
  end

  def update_value time
    for i in 0...@start_values.size
      @values[i] = value_at_time time, @start_values[i], @end_values[i]
    end
  end

end
end
