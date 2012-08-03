#-inject gen_class_header 'String'
class String

  def indent *args
    dup.indent! *args
  end

  def indent! n, spacer=" "
    space = spacer * n 
    self.gsub!({ "\n" => "\n" + space, "\r" => "\r" + space })
    self.replace(space + self)
    self
  end

  def word_wrap line_width=80
    text = self
    return text if line_width <= 0
    text.split("\n").collect do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  def word_wrap! chars=80
    self.replace word_wrap(chars)
  end

  def as_bool
    case self.upcase
      when *MACL::Parser::STRS_TRUE  ; return true
      when *MACL::Parser::STRS_FALSE ; return false
      else                           ; return nil
    end
  end

end