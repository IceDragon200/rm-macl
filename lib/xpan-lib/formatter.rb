#
# RGSS3-MACL/lib/xpan-lib/formatter.rb
#   by IceDragon
#   dc 04/04/2012
#   dm 04/04/2013
# vr 0.8.0
module MACL
module Formatter

  METRIC_NUM_BY_SYMBOL = {
                      'Y'  => (10**24),
                      'Z'  => (10**21),
                      'E'  => (10**18),
                      'P'  => (10**15),
                      'T'  => (10**12),
                      'G'  => (10**9),
                      'M'  => (10**6),
                      'k'  => (10**3),
                      'h'  => (10**2),
                      'da' => (10**1),
                      #' '  => (10**0),
                      #
                      'd'  => (10**-1).to_f,
                      'c'  => (10**-2).to_f,
                      'm'  => (10**-3).to_f,
                      'u'  => (10**-6).to_f,  # micro will just be aliased as u
                      'n'  => (10**-9).to_f,
                      'p'  => (10**-12).to_f,
                      'f'  => (10**-15).to_f,
                      'a'  => (10**-18).to_f,
                      'z'  => (10**-21).to_f,
                      'y'  => (10**-24).to_f
                    }

  METRIC_SYMBOL_BY_NUM = METRIC_NUM_BY_SYMBOL.invert

  REGEXP_METRIC_SYMBOLS = /(?<num>\d+(?:\.\d+)?)(?<symbol>#{METRIC_NUM_BY_SYMBOL.keys.sort.reverse.join("|")})/i

  def self.metric_str_to_num(string)
    if match_data = string.match(REGEXP_METRIC_SYMBOLS)
      num, sym = match_data[:num], match_data[:symbol]
      res = (num.include?(?.) ? num.to_f : num.to_i) * METRIC_NUM_BY_SYMBOL[sym]
      # if after rounding the result its equal to itself then return it as an
      # Integer else return as a Float
      return res.round(0) == res ? res.to_i : res.to_f
    else
      raise(ArgumentError, "Given string did not match any metric prefix")
    end
  end

  def self.num_to_metric_str(num, symbol=nil)
    if symbol
      divisor = METRIC_NUM_BY_SYMBOL[symbol]
      num = num.to_f if num < divisor
      quotient = num / divisor
      return (num.is_a?(Float) ? quotient.to_f : quotient.to_i).to_s + symbol
    else
      str = num.to_s
      # Is this a Float
      if pnt_index = str =~ /\./
        first, remaining = str.slice(pnt_index)
        # TODO
      # So the num is a Integer then
      else
        first, remaining = str[0], str[1, str.size]
        p [first, remaining]
        # So how many times must this be raised by a power of 10
        power = 10 ** remaining.size
        sym = METRIC_SYMBOL_BY_NUM[power]
        # did we find a symbol?
        if sym
          return first + "." + remaining + sym
        # too bad lets try tweaking the number a bit then
        else
          # TODO
        end
      end
    end
  end

end
end

#p MACL::Formatter.metric_str_to_num("10k")
#p MACL::Formatter.metric_str_to_num("1.21362579213k") # -> 1213.62579213
#p d = MACL::Formatter.num_to_metric_str(23, 'd')
#p MACL::Formatter.metric_str_to_num(d)
#p d = MACL::Formatter.num_to_metric_str(2869000)
#p MACL::Formatter.metric_str_to_num(d)
__END__
                        Metric prefixes
Prefix  Symbol   1000m    10n             Decimal         English word[n 1] Since[n 2]
yotta     Y     1000^8    10^24  1000000000000000000000000  septillion         1991
zetta     Z     1000^7    10^21     1000000000000000000000  sextillion         1991
exa       E     1000^6    10^18        1000000000000000000  quintillion        1975
peta      P     1000^5    10^15           1000000000000000  quadrillion        1975
tera      T     1000^4    10^12              1000000000000  trillion           1960
giga      G     1000^3    10^9                  1000000000  billion            1960
mega      M     1000^2    10^6                     1000000  million            1960
kilo      k     1000^1    10^3                        1000  thousand           1795
hecto     h     1000^2/3  10^2                         100  hundred            1795
deca      da    1000^1/3  10^1                          10  ten                1795
                1000^0    10^0                           1  one                –
deci      d     1000−1/3  10−1   0.1                        tenth              1795
centi     c     1000−2/3  10−2   0.01                       hundredth          1795
milli     m     1000−1    10−3   0.001                      thousandth         1795
micro     µ     1000−2    10−6   0.000001                   millionth          1960
nano      n     1000−3    10−9   0.000000001                billionth          1960
pico      p     1000−4    10−12  0.000000000001             trillionth         1960
femto     f     1000−5    10−15  0.000000000000001          quadrillionth      1964
atto      a     1000−6    10−18  0.000000000000000001       quintillionth      1964
zepto     z     1000−7    10−21  0.000000000000000000001    sextillionth       1991
yocto     y     1000−8    10−24  0.000000000000000000000001 septillionth       1991

^ This table uses the short scale.
^ The metric system was introduced in 1795 with six prefixes. The other dates relate to recognition by a resolution of the CGPM.
