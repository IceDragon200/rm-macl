class Numeric

  # // ROMAN and to_roman by Zetu
  ROMAN = {
        1 => "I",    5 => "V",    10 => "X",
       50 => "L",  100 => "C",   500 => "D",
     1000 => "M", 5000 => "" , 10000 => ""
  }

  def to_roman
    value = self
    return '---' if value >= 4000
    base = ""
    for key in ROMAN.keys.sort.reverse
      a = value / key
      case a
      when 0; next
      when 1, 2, 3
        base += ROMAN[key] * a
      when 4
        base += ROMAN[key]
        base += ROMAN[key * 5]
      when 5, 6, 7, 8
        base += ROMAN[key * 5]
        base += ROMAN[key] * a - 5
      when 9
        base += ROMAN[key * 10]
        base += ROMAN[key]
      end
      value -= a * key
    end
    return base
  end unless method_defined? :to_roman

end  
