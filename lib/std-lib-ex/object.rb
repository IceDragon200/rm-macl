#
# RGSS3-MACL/lib/std-lib-ex/object.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.2.1
class Object

  def marshal_clone
    Marshal.load(Marshal.dump(self))
  end unless method_defined?(:marshal_clone)

  def to_bool
    !!self
  end unless method_defined?(:to_bool)

  alias_method(:deep_clone, :marshal_clone) unless method_defined?(:deep_clone)

end
