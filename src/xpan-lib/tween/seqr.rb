#
# src/xpan-lib/tween/seqr.rb
#
#-// 31/01/2012
#-// 12/07/2012
#-inject gen_class_header 'Tween::Sequencer'
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

      def value n=0
        current.value n
      end

    end
  end
end
