#
# rm-macl/lib/rm-macl/xpan/rungekutta.rb
#   RungeKutta implementations
require 'rm-macl/macl-core'
module MACL
  module RungeKutta

    ##
    # euler(v, d, t, dt)
    #   Numeric v - Start Value
    #   Numeric d - Change Value
    #   Float t   - Current Time (0.0..1.0)
    #   Float dt  - Delta Time   (0.0..1.0)
    def euler(v, d, t, dt)
      v + d * (t + dt)
    end

    ##
    # rk4(v, d, t, dt)
    #   Numeric v - Start Value
    #   Numeric d - Change Value
    #   Float t   - Current Time (0.0..1.0)
    #   Float dt  - Delta Time   (0.0..1.0)
    def rk4(v, d, t, dt)
      k1 = euler(v, d, t, dt)
      k2 = euler(v, k1, t, dt * 0.5)
      k3 = euler(v, k2, t, dt * 0.5)
      k4 = euler(v, k1, t, dt)

      return (k1 + (k2 + k3) * 2.0 + k4) / 3.5
    end

    extend self

  end
end
MACL.register('macl/xpan/runge_kutta', '1.1.0')