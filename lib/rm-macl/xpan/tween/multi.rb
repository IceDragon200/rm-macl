#
# rm-macl/lib/rm-macl/xpan/tween/multi.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/tween/tween'
module MACL
  class Tween
    class Multi

      attr_reader :tweeners

      def initialize(*tweensets)
        set(*tweensets)
      end

      def clear
        @tweeners = []
      end

      def add_tween(tween)
        @tweeners << tween
      end

      def reset
        @tweeners.each(&:reset_time)
      end

      def set(*tweensets)
        clear
        tweensets.each { |t| add_tween(t) }
      end

      def done?
        return @tweeners.all?(&:done?)
      end

      def tweener(index)
        @tweeners[index]
      end

      def value(index, vindex=0)
        return @tweeners[index].value(vindex)
      end

      def values(index=nil)
        return index ? @tweeners[index].values : @tweeners.map(&:value)
      end

      def all_values
        return @tweeners.map(&:values)
      end

      def update
        @tweeners.each(&:update)
      end

    end
  end
end
MACL.register('macl/xpan/tween/multi', '1.1.0')