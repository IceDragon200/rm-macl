#
# RGSS3-MACL/lib/xpan-lib/colorv.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 21/03/2013
# vr 1.3.0
#   Using floats instead of integers
#
# CHANGES
#   27/03/2013 (vr 1.3.0)
#     Added
#       #to_h
#   21/03/2013 (vr 1.2.0)
#     Changed from ColorF to ColorVector
#     Added
#       Math functions (+ - * /)
#       #negate!
#       #affirm!
#
#   05/03/2013 (vr 1.1.0)
#     new-method
#       to_color24
#       to_color32
#     new-alias
#       to_color32 -> to_color
module MACL
  class ColorVector

    attr_reader :red, :green, :blue, :alpha

    def set(*args)
      case args.size
      when 1
        other, = args
        r, g, b, a = other.to_a
      when 3, 4
        r, g, b, a = args
        a ||= 255
      end
      self.red, self.green, self.blue, self.alpha = r, g, b, a
      return self
    end

    [:red, :green, :blue, :alpha].each do |sym|
      module_eval(%Q(
        def #{sym}=(new_#{sym})
          @#{sym} = [[new_#{sym}.to_f, 0.0].max, 1.0].min
        end
      ))
    end

    [[:add, :+], [:sub, :-], [:mul, :*], [:div, :/]].each do |(word, sym)|
      module_eval(%Q(
        def #{word}!(other)
          case other
          when ColorVector
            r, g, b, a = other.to_a
          when Numeric
            r = g = b = a = other.to_f
          end
          self.red    #{sym}= r
          self.green  #{sym}= g
          self.blue   #{sym}= b
          #self.alpha #{sym}= a
          return self
        end

        def #{word}(other)
          return dup.#{word}!(other)
        end
      ))
    end

    def negate!
      @red   = 1 - @red
      @green = 1 - @green
      @blue  = 1 - @blue
      #@alpha =
      return self
    end

    def affirm!
      self
    end

    def negate
      return dup.negate!
    end

    def affirm
      return dup.affirm!
    end

    def rgb_rate
      return red * green * blue
    end

    def argb_rate
      return red * green * blue * alpha
    end

    def to_a
      [red, green, blue, alpha]
    end

    def to_h
      return {red: red, green: green, blue: blue, alpha: alpha}
    end

    def to_rgb24_a
      [red * 255, green * 255, blue * 255]
    end

    def to_argb32_a
      [red * 255, green * 255, blue * 255, alpha * 255]
    end

    def to_color24
      Color.new(red * 255, green * 255, blue * 255, 255)
    end

    def to_color32
      Color.new(red * 255, green * 255, blue * 255, alpha * 255)
    end

    alias :initialize :set
    alias :to_color :to_color32

    alias :+ :add
    alias :- :sub
    alias :* :mul
    alias :/ :div

    alias :-@ :negate
    alias :+@ :affirm

  end
end