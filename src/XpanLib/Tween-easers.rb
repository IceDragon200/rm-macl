#-inject gen_class_header 'Tween::Easer'
class Tween
  class Easer
    attr_accessor :name,:symbol
    def initialize name=nil,&function
      @name = name || ".Easer"
      @symbol = :__easer
      @function = function
    end
    def _ease *args,&block
      @function.call *args,&block
    end
    def ease et, sv, ev, t, *args
      _ease et, sv, ev-sv, t, *args
    end
  end
  EASERS = []
  EASER_BY_SYMBOL = {}
  def self.add_easer str,&func
    mod,name = str.split("::")
    (name = mod; mod = nil) unless name
    modu = self
    if mod
      module_eval %Q(module #{mod} ; end) # // Initialize module
      modu = const_get(mod) 
    end
    easer = modu.__send__(:const_set,name,Easer.new(str,&func))
    sym   = easer.name.gsub('::',?_).downcase.to_sym
    EASER_BY_SYMBOL[sym] = easer
    EASER_BY_SYMBOL[sym].symbol = sym
    EASERS.push(easer)
  end
  #-// IceDragon
  #-// 01/26/2012
  #-// 01/26/2012
  #-// Null
  add_easer 'Null::In' do |t, st, ch, d| 
    st
  end
  add_easer 'Null::Out' do |t, st, ch, d|
    ch + st
  end
  #-// Linear
  add_easer "Linear"  do |t, st, ch, d| 
    ch * t / d + st 
  end
  #-// Sine
  add_easer "Sine::In"  do |t, st, ch, d|
    -ch * Math.cos(t / d * (Math::PI / 2)) + ch + st
  end
  add_easer "Sine::Out"  do |t, st, ch, d|
    ch * Math.sin(t / d * (Math::PI / 2)) + st
  end
  add_easer "Sine::InOut" do |t, st, ch, d|
    -ch / 2 * (Math.cos(Math::PI * t / d) - 1) + st
  end
  #-// Circ
  add_easer "Circ::In" do |t, st, ch, d|
    -ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st rescue st
  end
  add_easer "Circ::Out" do |t, st, ch, d|
    t = t/d - 1 ; ch * Math.sqrt(1 - t * t) + st rescue st
  end
  add_easer "Circ::InOut" do |t, st, ch, d|
    (t /= d/2.0) < 1 ?
     -ch / 2 * (Math.sqrt(1 - t*t) - 1) + st :
      ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st rescue st
  end
  #-// Bounce
  add_easer "Bounce::Out" do |t, st, ch, d|
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
  add_easer "Bounce::In" do |t, st, ch, d|
    ch - Bounce::Out.ease(d-t, 0, ch, d) + st
  end
  add_easer "Bounce::InOut"  do |t, st, ch, d|
    t < d/2.0 ?
      Bounce::In.ease(t*2.0, 0, ch, d) * 0.5 + st :
      Bounce::Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
  end
  #-// Back
  add_easer "Back::In" do |t, st, ch, d, s=1.70158|
    ch * (t/=d) * t * ((s+1) * t - s) + st
  end
  add_easer "Back::Out" do |t, st, ch, d, s=1.70158|
    ch * ((t=t/d-1) * t * ((s+1) * t + s) + 1) + st
  end
  add_easer "Back::InOut" do |t, st, ch, d, s=1.70158|
    (t /= d/2.0) < 1 ?
      ch / 2.0 * (t * t * (((s *= (1.525)) + 1) * t - s)) + st :
      ch / 2.0 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + st
  end
  #-// Cubic
  add_easer "Cubic::In" do |t, st, ch, d| 
    ch * (t /= d) * t * t + st 
  end
  add_easer "Cubic::Out" do |t, st, ch, d|
    ch * ((t = t / d.to_f - 1) * t * t + 1) + st
  end
  add_easer "Cubic::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t * t * t + st :
      ch / 2.0 * ((t -= 2) * t * t + 2) + st
  end
  #-// Expo
  add_easer "Expo::In" do |t, st, ch, d|
    t == 0 ? st : ch * (2 ** (10 * (t / d.to_f - 1))) + st
  end
  add_easer "Expo::Out" do |t, st, ch, d|
    t == d ? st + ch : ch * (-(2 ** (-10 * t / d.to_f)) + 1) + st
  end
  add_easer "Expo::InOut" do |t, st, ch, d|
    if t == 0                ; st
    elsif t == d             ; st + ch
    elsif (t /= d / 2.0) < 1 ; ch / 2.0 * (2 ** (10 * (t - 1))) + st
    else                     ; ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
    end
  end
  #-// Quad
  add_easer "Quad::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t + st
  end
  add_easer "Quad::Out" do |t, st, ch, d|
    -ch * (t /= d.to_f) * (t - 2) + st
  end
  add_easer "Quad::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 2 + st :
      -ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st
  end
  #-// Quart
  add_easer "Quart::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t ** 3 + st
  end
  add_easer "Quart::Out" do |t, st, ch, d|
    -ch * ((t = t / d.to_f - 1) * t ** 3 - 1) + st
  end
  add_easer "Quart::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 4 + st :
      -ch / 2.0 * ((t -= 2) * t ** 3 - 2) + st
  end
  #-// Quint
  add_easer "Quint::In" do |t, st, ch, d|
    ch * (t /= d.to_f) * t ** 4 + st
  end
  add_easer "Quint::Out" do |t, st, ch, d|
    ch * ((t = t / d.to_f - 1) * t ** 4 + 1) + st
  end
  add_easer "Quint::InOut" do |t, st, ch, d|
    (t /= d / 2.0) < 1 ?
      ch / 2.0 * t ** 5 + st :
      ch / 2.0 * ((t -= 2) * t ** 4 + 2) + st
  end
  #-// Elastic
  add_easer "Elastic::In" do |t, st, ch, d, a = 5, p = 0|
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
  add_easer "Elastic::Out" do |t, st, ch, d, a = 5, p = 0|
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