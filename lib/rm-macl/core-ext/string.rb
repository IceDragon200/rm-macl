#
# RGSS3-MACL/lib/core-ext/string.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 14/04/2013
# vr 1.3.0
class String

  ##
  # indent!(int indent_amount, char filler)
  def indent!(indent_amount, filler=" ")
    space = filler * indent_amount
    replace(each_line.map { |line| space + line }.join(''))
    self
  end

  ##
  # indent(int indent_amount, char filler)
  def indent(*args)
    dup.indent!(*args)
  end

  ##
  # line_wrap(int line_width)
  #   http://www.java2s.com/Code/Ruby/String/WordwrappingLinesofText.htm
  def line_wrap(width=80)
    self.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

  ##
  # line_wrap!(int line_width)
  def line_wrap!(width=80)
    self.replace(line_wrap(width))
  end

  ##
  # shift! -> char
  def shift!
    c = self[0]
    self.replace(self[1...length])
    return c
  end

  ##
  # pop! -> char
  def pop!
    c = self[-1]
    self.replace(self[0...length-1])
    return c
  end

  ##
  # shift -> char
  def shift
    dup.shift!
  end

  ##
  # pop -> char
  def pop
    dup.pop!
  end

  ##
  # remove_whitespace!(Symbol from)
  def remove_whitespace!(from=:start)
    case from
    when :start then shift! while start_with?(" ") and length > 0
    when :end   then pop! while end_with?(" ") and length > 0
    end
    self
  end

  ##
  # remove_whitespace(Symbol from)
  def remove_whitespace(*args)
    dup.remove_whitespace!(*args)
  end

  ##
  # first_significant? -> Boolean
  def first_significant?(char)
    i = 0
    i += 1 while (self[i] == " " and not i > length)
    self[i] == char
  end

end
