#
# rm-macl/lib/rm-macl/xpan/tween/seqr.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/tween/tween'
require 'rm-macl/xpan/sequencer'
module MACL
  class Tween
    class Sequencer < MACL::Sequenex

      def add_tween(*args, &block)
        add(Tween.new(*args, &block))
      end

      def total_time
        @list.inject(0) { |r, t| r + t.maxtime }
      end

      def values
        current.values
      end

      def value(n = 0)
        current.value n
      end

    end
  end
end
MACL.register('macl/xpan/tween/sequencer', '1.1.0')