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
class Tween
  attr_reader :values
  attr_reader :start_values
  attr_reader :end_values
  attr_reader :time
  attr_reader :maxtime
  class << self
    def init
      @@_add_time = (1.0 / Graphics.frame_rate) 
    end
    def frames_to_tt( frames )
      frames * @@_add_time
    end 
    alias f2tt frames_to_tt
    alias frm2sec f2tt
    def tt_to_frames( tt )
      (tt * Graphics.frame_rate).to_i
    end 
    alias tt2f tt_to_frames 
    alias sec2frm tt2f
    def _add_time
      @@_add_time
    end  
  end
  def initialize( start_values=[], end_values=[], easer=:linear, maxtime=1.0, extra_params=[] )
    set_and_reset( start_values, end_values, easer, maxtime, extra_params )
  end 
  def value( index=0 )
    return @values[index]
  end  
  def start_value index=0 
    return @start_values[index]
  end  
  def end_value index=0  
    return @end_values[index]
  end  
  def set start_values=[],end_values=[],easer=:linear,maxtime=1.0,extra_params=[]
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
    return Tween::EASER_SYMBOLS[@easer]
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
  def update_to_end
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
# ╒╕ ♥                                                         Tween::Multi ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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
# ╒╕ ♥                                                           Tween::Osc ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Osc
  attr_reader :index
  attr_reader :tindex
  attr_reader :cycles
  def initialize *args,&block  
    normal_cycle
    set *args,&block 
    set_cycles -1
    reset
  end 
  def reset
    @tindex = 0
    @index = 0
    @tweeners.each { |t| t.reset! }
  end  
  def set_cycles n 
    @cycles = n
  end  
  def invert_cycle
    @inverted = true
  end  
  def normal_cycle
    @inverted = false
  end  
  def set svs, evs, easers=[:linear, :linear], maxtimes=[1.0,1.0] 
    @tweeners = []
    for i in 0...easers.size
      args = (i % 2 == 0 ? [svs, evs] : [evs, svs]) + [easers[i], maxtimes[i%maxtimes.size]]
      @tweeners[i] = Tween.new *args 
    end
    self
  end  
  def total_time
    @tweeners.inject 0 do |r, t| r + t.maxtime end
  end 
  def done?
    return @tindex / @tweeners.size >= @cycles unless @cycles == -1
    return false
  end  
  def update
    return if done?
    if @tweeners[@index].done?
      @index = (@inverted ? @index.pred : @index.succ) % @tweeners.size
      @tindex = @tindex.succ
      @tweeners[@index].reset_time
    end  
    @tweeners[@index].update
  end  
  def values
    @tweeners[@index].values
  end 
  def value n=0 
    @tweeners[@index].value n 
  end  
end 
# ╒╕ ♥                                                     Tween::Sequencer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Seqeuncer
  attr_reader :index
  attr_reader :tweeners
  def initialize
    @tweeners = []
    @index = 0
  end 
  def add_tween *args,&block 
    @tweeners << Tween.new(*args,&block)
  end  
  def reset
    @index = 0
    @tweeners.each { |t| t.reset! }
  end    
  def total_time
    @tweeners.inject(0) { |r, t| r + t.maxtime }
  end 
  def done?
    @tweeners.all?{|t|t.done?}
  end
  def update
    return if done?
    @index = (@inverted ? @index.pred : @index.succ) if @tweeners[@index].done?
    @tweeners[@index].update
  end  
  def values
    @tweeners[@index].values
  end 
  def value n=0 
    @tweeners[@index].value n 
  end
end  
# ╒╕ ♥                                                         Tween::Easer ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween::Easer
  attr_accessor :name,:symbol
  class << self
    alias :old_new :new
    def new *args,&function 
      obj = old_new *args 
      # // time, start_value, change_value, current_time/elapsed_time
      @function = function
      class << obj ; define_method(:_ease,&@function) ; end
      @function = nil
      obj
    end
  end
  def initialize name=nil 
    @name = name || ".Easer"
    @symbol = :__easer
  end  
  def ease et, sv, ev, t, *args 
    _ease et, sv, ev-sv, t, *args 
  end  
end  
# ╒╕ ♥                                                        Tween::Easers ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Tween 
  module Null
    In   = Easer.new "Null::In" do |t, st, ch, d| st end
    Out  = Easer.new "Null::Out"  do |t, st, ch, d| ch + st end
  end 
  module Bee
    In    = Easer.new "Bee::In"  do |t, st, ch, d, b=4.0|
      (ch * t / d + st) + (-ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b) 
    end
    Out    = Easer.new "Bee::Out"  do |t, st, ch, d, b=4.0| 
      (ch * t / d + st) + (ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b) 
    end
    InOut = Easer.new "Bee::InOut"  do |t, st, ch, d, b=4.0| 
      t < d/2.0 ? 
        In.ease(t*2.0, 0, ch, d, b) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d, b) * 0.5 + ch * 0.5 + st
    end
  end
  # // 01/26/2012
  # // 01/26/2012
  module Modulate
    Out = Easer.new "Modulate::Out"  do |t, st, ch, d, e1=:linear, e2=:linear|
      return st if ch == 0
      Tween::EASER_SYMBOLS[e1].ease(t, 0, ch, d) * (Tween::EASER_SYMBOLS[e2].ease(t, 0, ch, d) / ch) + st
    end
    In = Easer.new "Modulate::In"  do |t, st, ch, d, e1=:linear, e2=:linear|
      return st if ch == 0
      Tween::EASER_SYMBOLS[e1].ease(t, 0, ch, d) * (1.0-(Tween::EASER_SYMBOLS[e2].ease(d-t, 0, ch, d) / ch)) + st
    end
    InOut = Easer.new "Modulate::InOut"  do |t, st, ch, d, e1=:linear, e2=:sine_in|
      t < d/2.0 ? 
        In.ease(t*2.0, 0, ch, d) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
    end
  end  
  # // Jet
  Linear  = Easer.new "Linear"  do |t, st, ch, d| ch * t / d + st end
  module Sine 
    In    = Easer.new "Sine::In"  do |t, st, ch, d| 
      -ch * Math.cos(t / d * (Math::PI / 2)) + ch + st 
    end
    Out   = Easer.new "Sine::Out"  do |t, st, ch, d| 
      ch * Math.sin(t / d * (Math::PI / 2)) + st 
    end
    InOut = Easer.new "Sine::InOut" do |t, st, ch, d| 
      -ch / 2 * (Math.cos(Math::PI * t / d) - 1) + st 
    end
  end
  module Circ  
    In    = Easer.new "Circ::In" do |t, st, ch, d| 
      -ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st rescue st
    end
    Out   = Easer.new "Circ::Out" do |t, st, ch, d| 
      t = t/d - 1 ; ch * Math.sqrt(1 - t * t) + st rescue st
    end
    InOut = Easer.new "Circ::InOut" do |t, st, ch, d| 
      (t /= d/2.0) < 1 ? 
       -ch / 2 * (Math.sqrt(1 - t*t) - 1) + st : 
        ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st rescue st
    end
  end  
  module Bounce
    Out    = Easer.new "Bounce::Out" do |t, st, ch, d| 
      if (t /= d) < (1/2.75)
        ch * (7.5625 * t * t) + st
      elsif t < (2 / 2.75)
        ch * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + st
      elsif t < (2.5 / 2.75)
        ch * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + st
      else
        ch * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + st
      end
    end
    In    = Easer.new "Bounce::In" do |t, st, ch, d|
      ch - Out.ease(d-t, 0, ch, d) + st 
    end
    InOut = Easer.new "Bounce::InOut"  do |t, st, ch, d| 
      t < d/2.0 ? 
        In.ease(t*2.0, 0, ch, d) * 0.5 + st :
        Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
    end
  end  
  module Back  
    In    = Easer.new "Back::In" do |t, st, ch, d, s=1.70158| 
      ch * (t/=d) * t * ((s+1) * t - s) + st 
    end
    Out   = Easer.new "Back::Out" do |t, st, ch, d, s=1.70158| 
      ch * ((t=t/d-1) * t * ((s+1) * t + s) + 1) + st 
    end
    InOut = Easer.new "Back::InOut" do |t, st, ch, d, s=1.70158| 
      (t /= d/2.0) < 1 ?
        ch / 2.0 * (t * t * (((s *= (1.525)) + 1) * t - s)) + st :
        ch / 2.0 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + st
    end
  end  
  module Cubic 
    In    = Easer.new "Cubic::In" do |t, st, ch, d| ch * (t /= d) * t * t + st end
    Out   = Easer.new "Cubic::Out" do |t, st, ch, d| 
      ch * ((t = t / d.to_f - 1) * t * t + 1) + st 
    end
    InOut = Easer.new "Cubic::InOut" do |t, st, ch, d| 
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t * t + st :
        ch / 2.0 * ((t -= 2) * t * t + 2) + st
    end
  end
  module Expo  
    In    = Easer.new "Expo::In" do |t, st, ch, d| 
      t == 0 ? st : ch * (2 ** (10 * (t / d.to_f - 1))) + st 
    end
    Out   = Easer.new "Expo::Out" do |t, st, ch, d| 
      t == d ? st + ch : ch * (-(2 ** (-10 * t / d.to_f)) + 1) + st 
    end
    InOut = Easer.new "Expo::InOut" do |t, st, ch, d| 
      if t == 0                ; st
      elsif t == d             ; st + ch
      elsif (t /= d / 2.0) < 1 ; ch / 2.0 * (2 ** (10 * (t - 1))) + st
      else                     ; ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
      end
    end
  end  
  module Quad
    In    = Easer.new "Quad::In" do |t, st, ch, d| 
      ch * (t /= d.to_f) * t + st 
    end
    Out   = Easer.new "Quad::Out" do |t, st, ch, d| 
      -ch * (t /= d.to_f) * (t - 2) + st 
    end
    InOut = Easer.new "Quad::InOut" do |t, st, ch, d| 
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t + st : 
        -ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st 
    end
  end  
  module Quart
    In    = Easer.new "Quart::In" do |t, st, ch, d| 
      ch * (t /= d.to_f) * t * t * t + st
    end
    Out   = Easer.new "Quart::Out" do |t, st, ch, d|
      -ch * ((t = t / d.to_f - 1) * t * t * t - 1) + st 
    end
    InOut = Easer.new "Quart::InOut" do |t, st, ch, d| 
      (t /= d / 2.0) < 1 ? 
        ch / 2.0 * t * t * t * t + st :
        -ch / 2.0 * ((t -= 2) * t * t * t - 2) + st
    end
  end  
  module Quint
    In    = Easer.new "Quint::In" do |t, st, ch, d| 
      ch * (t /= d.to_f) * t * t * t * t + st 
    end
    Out   = Easer.new "Quint::Out" do |t, st, ch, d| 
      ch * ((t = t / d.to_f - 1) * t * t *t * t + 1) + st 
    end
    InOut = Easer.new "Quint::InOut" do |t, st, ch, d| 
      (t /= d / 2.0) < 1 ?
        ch / 2.0 * t * t *t * t * t + st :
        ch / 2.0 * ((t -= 2) * t * t * t * t + 2) + st
    end
  end  
  module Elastic
    In    = Easer.new "Elastic::In" do |t, st, ch, d, a = 5, p = 0| 
      s = 0
      if t == 0 
        st
      elsif (t /= d.to_f) >= 1
        st + ch
      else  
        p = d * 0.3 if p == 0
        if (a == 0) || (a < ch.abs)
          a = ch
          s = p / 4.0
        else
          s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
        end
        -(a * (2 ** (10 * (t -= 1))) * Math.sin( (t * d - s) * (2 * Math::PI) / p)) + st
      end
    end
    Out   = Easer.new "Elastic::Out" do |t, st, ch, d, a = 5, p = 0|  
      s = 0
      if t == 0
        st
      elsif (t /= d.to_f) >= 1
        st + ch
      else  
        p = d * 0.3 if p == 0
        if (a == 0) || (a < ch.abs)
          a = ch
          s = p / 4.0
        else
          s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
        end
        a * (2 ** (-10 * t)) * Math.sin((t * d - s) * (2 * Math::PI) / p.to_f) + ch + st
      end  
    end
  end  
end  
class Tween
  EASERS = [
    Null::In,
    Null::Out,
    
    Linear,
    
    Sine::In,
    Sine::Out,
    Sine::InOut,
    
    Circ::In,
    Circ::Out,
    Circ::InOut,
    
    Bounce::In,
    Bounce::Out,
    Bounce::InOut,
    
    Back::In,
    Back::Out,
    Back::InOut,
    
    Cubic::In,
    Cubic::Out,
    Cubic::InOut,
    
    Expo::In,
    Expo::Out,
    Expo::InOut,
    
    Quad::In,
    Quad::Out,
    Quad::InOut,
    
    Quart::In,
    Quart::Out,
    Quart::InOut,
    
    Quint::In,
    Quint::Out,
    Quint::InOut,
    
    Elastic::In,
    Elastic::Out,
    
    Bee::In,
    Bee::Out,
    Bee::InOut,
    
    #Modulate::In,
    #Modulate::Out,
    #Modulate::InOut
  ]
  EASER_SYMBOLS = { }
  EASERS.each { |e| 
    sym = e.name.gsub(/\:\:/i,"_").downcase.to_sym
    EASER_SYMBOLS[sym] = e 
    EASER_SYMBOLS[sym].symbol = sym
  }
end
MACL.add_init :tween, Tween.method(:init)