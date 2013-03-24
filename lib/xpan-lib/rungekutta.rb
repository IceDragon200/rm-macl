#
# RGSS3-MACL/lib/xpan-lib/rungekutta.rb
#   by IceDragon
#   dc 22/03/2013
#   dm 22/03/2013
# vr 1.0.0
#   RungeKutta implementations
module MACL
module RungeKutta

  def euler(v, t, dt, d)
    v + d * (t + dt)
  end

  def rk4(v, t, dt, d)
    k1 = euler(t, 0.0, v, d)
    k2 = euler(t, dt * 0.5, v, k1)
    k3 = euler(t, dt * 0.5, v, k2)
    k4 = euler(t, dt, v, k3)

    return (k1 + (k2 + k3) * 2.0 + k4) * (1.0 / 6.0)
  end

  extend self

end
end

RK = MACL::RungeKutta
(0..12).each do |i|
  p RK.rk4(0.0, i / 12.0, 0.0, 4.0)
end

