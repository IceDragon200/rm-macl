#
# RGSS3-MACL/lib/std-lib-ex/string.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.2.0
class String

  def indent(*args)
    dup.indent! *args
  end

  def indent!(n, spacer=" ")
    space = spacer * n
    self.gsub!({ "\n" => "\n" + space, "\r" => "\r" + space })
    self.replace(space + self)
    self
  end

  def word_wrap(line_width=80)
    text = self
    return text if line_width <= 0
    text.split("\n").collect do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  def word_wrap!(chars=80)
    self.replace(word_wrap(chars))
  end

  def shift!
    self.replace(self[1...length])
  end

  def pop!
    self.replace(self[0...length-1])
  end

  def remove_whitespace!(at=:start)
    shift! while start_with?(" ") and length > 0 if at == :start
    pop! while end_with?(" ") and length > 0 if at == :end
    self
  end

  def first_significant?(char)
    i = 0
    i += 1 while(self[i] == " " and not i > length)
    return self[i] == char
  end

  def shift
    dup.shift!
  end

  def pop
    dup.pop!
  end

  def remove_whitespace(*args, &block)
    dup.remove_whitespace!(*args, &block)
  end

end
