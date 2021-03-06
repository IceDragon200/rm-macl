#
# rm-macl/lib/rm-macl/xpan/tween/multi.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/tween/tween'
require 'rm-macl/xpan/tween/sequencer'
module MACL
  class Tween
    class Osc < Sequencer

      def initialize(*args, &block)
        super()
        set(*args, &block)
        @cycles = -1
        reset
      end

      def on_cycle
        super
        reverse
      end

      def set(svs, evs, easers=[:linear, :linear], maxtimes=[1.0, 1.0])
        easers = [easers] * 2 unless easers.kind_of?(Enumerable)
        maxtimes = [maxtimes] * 2 unless maxtimes.kind_of?(Enumerable)
        for i in 0...easers.size
          args = (i % 2 == 0 ? [svs, evs] : [evs, svs]) + [easers[i], maxtimes[i%maxtimes.size]]
          @list[i] = Tween.new *args
        end
        self
      end

    end
  end
end
MACL.register('macl/xpan/tween/osc', '1.1.0')