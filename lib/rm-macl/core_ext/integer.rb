#
# rm-macl/lib/rm-macl/core_ext/integer.rb
#   by IceDragon
class Integer

  ##
  # to_roman
  #   Converts Numeric to a Roman numeral String
  def to_roman
    roman = {
        1 => "I",    5 => "V",    10 => "X",
       50 => "L",  100 => "C",   500 => "D",
     1000 => "M", 5000 => "" , 10000 => ""
    }
    value = self
    return '---' if value >= 4000
    base = ""
    for key in roman.keys.sort.reverse
      a = value / key
      case a
      when 0; next
      when 1, 2, 3
        base += roman[key] * a
      when 4
        base += roman[key]
        base += roman[key * 5]
      when 5, 6, 7, 8
        base += roman[key * 5]
        base += roman[key] * a - 5
      when 9
        base += roman[key * 10]
        base += roman[key]
      end
      value -= a * key
    end
    return base
  end unless method_defined? :to_roman

  ##
  # count(int n) { |current_step| }
  #   Counts the number of iterations and returns it.
  #   Counting starts from the Numeric, counting is done by adding (n)
  def count(n=1)
    i = self
    loop do
      yield i
      i = i + n
    end
    i
  end unless method_defined? :count

end