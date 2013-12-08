#
# rm-macl/lib/rm-macl/core_ext/module.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Module

  attr_reader :__cast

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
  # tcast_set(Class* klass) { |obj| return klass.instance }
  def tcast_set(klass, &func)
    (@__cast ||= {})[klass] = func
  end

  ##
  # tcast(Object* obj) -> self.instance
  #   Attempts to cast the object as this type, else raises a TypeError
  def tcast(obj)
    self.ancestors.each do |k|
      if cast_list = k.__cast
        cast_klass = obj.class.ancestors.find { |klass| cast_list.has_key?(klass) }
        if cast = cast_list[cast_klass || :default]
          return instance_exec(obj, &cast)
        end
      end
    end
    raise TypeError, "could not convert type #{obj.class} to #{self}"
  end

  protected :__cast

end
MACL.register('macl/core_ext/module', '2.2.0')