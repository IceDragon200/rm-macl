# ╒╕ ■                                                                 Mimi ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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