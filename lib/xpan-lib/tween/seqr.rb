#
# RGSS3-MACL/lib/xpan-lib/seqr.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'tween')
require File.join(File.dirname(__FILE__), '..', 'sequen')

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
