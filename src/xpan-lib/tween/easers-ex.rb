#
# src/xpan-lib/tween/easers-ex.rb
#
MACL.add_init 'tween:ease:ex' do
class MACL::Tween
  add_easer 'Bee::In' do |t, st, ch, d, b=4.0|
    (ch * t / d + st) + (-ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b)
  end
  add_easer 'Bee::Out' do |t, st, ch, d, b=4.0|
    (ch * t / d + st) + (ch * Math.sin(Math.cos((b * t / d)*Math::PI)*Math::PI) / b)
  end
  add_easer 'Bee::InOut' do |t, st, ch, d, b=4.0|
    t < d/2.0 ?
      Bee::In.ease(t*2.0, 0, ch, d, b) * 0.5 + st :
      Bee::Out.ease(t*2.0 - d, 0, ch, d, b) * 0.5 + ch * 0.5 + st
  end
  #-// 01/26/2012
  #-// 01/26/2012
  #-// Modulate
  add_easer "Modulate::Out" do |t, st, ch, d, e1=:linear, e2=:linear|
    return st if ch == 0
    Tween::EASER_BY_SYMBOL[e1].ease(t, 0, ch, d) * (Tween::EASER_BY_SYMBOL[e2].ease(t, 0, ch, d) / ch) + st
  end
  add_easer "Modulate::In" do |t, st, ch, d, e1=:linear, e2=:linear|
    return st if ch == 0
    Tween::EASER_BY_SYMBOL[e1].ease(t, 0, ch, d) * (1.0-(Tween::EASER_BY_SYMBOL[e2].ease(d-t, 0, ch, d) / ch)) + st
  end
  add_easer "Modulate::InOut" do |t, st, ch, d, e1=:linear, e2=:sine_in|
    t < d/2.0 ?
      Bee::In.ease(t*2.0, 0, ch, d) * 0.5 + st :
      Bee::Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
  end

end
end
