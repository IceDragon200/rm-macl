# // 05/17/2012
# // 05/17/2012
# // Created By : IceDragon
module LogicGates
  # // I am aware I didnt have to put ? true : false ternaries,
  # // but just for readability
  def And a,b
    a and b ? true : false
  end
  def Or a,b
    a or b ? true : false
  end
  def Buffer a
    !!a
  end
  def Invert a
    !a
  end
  def NAnd a,b
    a and b ? false : true
  end
  def NOr a,b
    a or b ? false : true
  end
  def XOr a,b
    a or b and not a and b ? true : false
  end
  def XNOr a,b
    a and b or !a and !b ? true : false
  end
end