#
# rm-macl/lib/rm-macl/xpan/formatter.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
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
MACL.register('macl/xpan/formatter', '0.8.0')