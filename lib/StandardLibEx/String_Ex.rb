# ╒╕ ♥                                                               String ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class String
  def indent *args 
    dup.indent! *args 
  end
  def indent! n=0,s=" "
    self.replace(s*n+self)
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
end