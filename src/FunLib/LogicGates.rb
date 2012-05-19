# // 05/17/2012
# // 05/17/2012
# // Created By : IceDragon
module LogicGates
  # // I am aware I didnt have to put ? true : false ternaries,
  # // but just for readability
  def self.And(a,b)
    a and b ? true : false
  end
  def self.Or(a,b)
    a or b ? true : false
  end
  def self.Buffer(a)
    !!a
  end
  def self.Invert(a)
    !a
  end
  def self.NAnd(a,b)
    a and b ? false : true
  end
  def self.NOr(a,b)
    a or b ? false : true
  end
  def self.XOr(a,b)
    a or b and not a and b ? true : false
  end
  def self.XNOr(a,b)
    a and b or !a and !b ? true : false
  end
end