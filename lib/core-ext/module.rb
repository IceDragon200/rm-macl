#
# RGSS3-MACL/lib/core-ext/module.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 22/05/2013
# vr 2.0.0
class Module

  ##
  # assert_type(Object obj)
  #   Checks if obj is #kind_of?(self), raise a TypeError if false, else
  #   returns true
  def assert_type(obj)
    raise(TypeError,
          "expected kind of #{self} but recieved #{obj.class}"
          ) unless obj.kind_of?(self)
    return true
  end

  ### Typecasting :D
  ##
  # set_caster(Class* klass) { |obj| return klass.instance }
  def set_caster(klass, &func)
    (@__cast ||= {})[klass] = func
  end

  ##
  # cast(Object* obj) -> self.instance
  #   Attempts to cast the object as this type, else raises a TypeError
  def cast(obj)
    if @__cast && caster = @__cast[obj.class]
      return caster.call(obj)
    else
      raise TypeError, "could not convert type %s to %s" % [obj.class, self]
    end
  end

end
