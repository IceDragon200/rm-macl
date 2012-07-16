#-unlessdef xMACLBUILD
#==============================================================================#
# ♥ Tween
#==============================================================================#
# // • Created By    : CaptainJet
# // • Modified By   : IceDragon
# // • Data Created  : 12/15/2011
# // • Data Modified : 01/03/2012
# // • Version       : 1.0
#==============================================================================#
# // Special Credits To:
# Robert Penner (For whatever reason Jet mentioned him)
# UziMonkey (For whatever reason Jet mentioned him)
# CaptainJet (For teh script)
#
#==============================================================================#
# ● Change Log
#     ♣ 12/15/2011 V1.0
#     ♣ 01/03/2012 V1.0
#         Fixed
#           Small bug with Tween value_at_time
#
#==============================================================================#
#-else:
#-apndmacro _imported_
#-inject gen_scr_imported 'Tween', '0x11000'
#-end:
#-inject gen_class_header 'Tween'
#-end:
#-// Sequenex Ready
class Tween
  class TStruct
    attr_accessor :easer,:time
    def initalize easer,time
      @easer,@time = easer,time
    end
    def to_tween start_values,end_values
      Tween.new start_values,end_values,@easer,@time
    end
  end
  class TweenError < StandardError
  end
  attr_reader :values, :start_values, :end_values
  attr_reader :time, :maxtime
  class << self
    def init
      @@_add_time = 1.0 / Graphics.frame_rate
    end
    def _add_time
      @@_add_time
    end    
    def frm2sec frames
      frames * @@_add_time
    end
    def sec2frm sec
      Integer(sec) * Graphics.frame_rate
    end
  end
#-skip:
  init
#-end:  
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
  # // Cross support
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
    @time = (@time-@@_add_time).max 0
  end
  def succ_time
    @time = (@time+@@_add_time).min @maxtime
  end
  def time_rate
    time_to_rate @time
  end
  def time_to_rate t=@time
    t / @maxtime
  end
  def value_at_time time, sv=@start_values[0], ev=@end_values[0], mt=@maxtime, exp=@extra_params
    easer.ease time, sv, ev, mt, *exp
  end
  def invert
    @start_values,@end_values = @end_values,@start_values
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
#-inject gen_class_header 'Tween::Multi'
class Tween::Multi
  attr_reader :tweeners
  def initialize *tweensets
    set *tweensets
  end
  def set *tweensets
    clear
    tweensets.each do |tset|
      add_tween *tset
    end
  end
  def done?
    return @tweeners.all? { |t| t.done? }
  end
  def clear
    @tweeners = []
  end
  def tweener index
    @tweeners[index]
  end
  def tweener_value index, vindex
    @tweeners[index].value vindex
  end
  def tweener_values index
    @tweeners[index].values
  end
  def add_tween *args
    @tweeners << Tween.new(*args)
  end
  def reset
    @tweeners.each do |t| t.reset_time ; end
  end
  def value index
    @tweeners[index].value
  end
  def values
    @tweeners.collect do |t| t.value ; end
  end
  def all_values
    @tweeners.collect { |t| t.values ; }.flatten
  end
  def update
    @tweeners.each do |t| t.update ; end
  end
end
#-// 31/01/2012
#-// 12/07/2012
#-inject gen_class_header 'Tween::Sequencer'
class Tween::Sequencer < MACL::Sequenex
  def add_tween *args,&block
    add(Tween.new(*args,&block))
  end
  def total_time
    @list.inject(0) { |r, t| r + t.maxtime }
  end
  def values
    current.values
  end
  def value n=0
    current.value n
  end
end
#-// 26/01/2012
#-// 12/07/2012
#-inject gen_class_header 'Tween::Osc'
class Tween::Osc < Tween::Sequencer
  def initialize *args,&block
    super()
    set *args,&block
    @cycles = -1
    reset!
  end
  def on_cycle
    super
    reverse!
  end
  def set svs, evs, easers=[:linear, :linear], maxtimes=[1.0,1.0]
    for i in 0...easers.size
      args = (i % 2 == 0 ? [svs, evs] : [evs, svs]) + [easers[i], maxtimes[i%maxtimes.size]]
      @list[i] = Tween.new *args
    end
    self
  end
end
#-inject gen_function_des 'MACL.add_init'
MACL.add_init :tween, Tween.method(:init)
#-skip 1
require_relative 'tween-easers'