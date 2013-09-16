#
# RGSS3-MACL/lib/xpan-lib/tween/tween_struct.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'tween')

module MACL
  class Tween
    class TweenStruct

      attr_accessor :easer, :time

      def initalize(easer, time)
        @easer, @time = easer, time
      end

      def to_tween(start_values, end_values)
        Tween.new(start_values, end_values, @easer, @time)
      end

    end
  end
end
