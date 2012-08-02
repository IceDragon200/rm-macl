#-inject gen_class_header 'String'
class String

  def indent *args
    dup.indent! *args
  end

  def indent! n=0,s=" "
    space =s * n 
    self.gsub!({ "\n" => "\n" + space, "\r" => "\r" + space })
    self.replace space + self
  end

  def word_wrap chars=80
    char_count = 0
    arra = []
    result_str = ''
    self.scan(/(\S+)/i).each do |str|
      if char_count + str.size < str.chars
        char_count += str.size
        arra << str
      else
        result_str += arra.join(' ')+"\n"
        char_count,arra = 0,[]
      end
    end
  end

  def word_wrap! chars=80
    self.replace word_wrap(chars)
  end

  def character_wrap characters=459
    text = self
    return text if characters <= 0
    white_space = " "
    result,r = [],""
    text.split(' ').each do |word|
      (result << r;r = "") if r.size + word.size > characters
      r << word+white_space
    end
    result << r unless r.empty?
    result
  end

  def as_bool
    case self.upcase
      when *MACL::Parser::STRS_TRUE  ; return true
      when *MACL::Parser::STRS_FALSE ; return false
      else                           ; return nil
    end
  end

end