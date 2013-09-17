#
# rm-macl/lib/rm-macl/core-ext/module.rb
#
require 'rm-macl/macl-core'
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
  # tcast(Object* obj) -> self.instance
  #   Attempts to cast the object as this type, else raises a TypeError
  def tcast(obj)
    if @__cast
      cast_klass = obj.class.ancestors.find { |klass| @__cast[klass] }
      if cast_klass && caster = @__cast[cast_klass]
        return caster.call(obj)
      end
    end
    raise TypeError, "could not convert type #{obj.class} to #{self}"
  end

end
MACL.register('macl/core/module', '2.1.0')