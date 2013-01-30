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
