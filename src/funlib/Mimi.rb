#-// Mimi 28/06/2012 28/06/2012
#-inject gen_module_header 'Mimi'
module Mimi
  def int num
    "%x" % num
  end
  def int2 num
    "%02x" % num
  end
  def intn num,bits
    "%0{bits}x" % num
  end
  def str
  end
  def bool
    
  end
end