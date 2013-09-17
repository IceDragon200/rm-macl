#
# rm-macl/lib/rm-macl/core-ext/object.rb
#
require 'rm-macl/macl-core'
class Object

  ##
  # marshal_clone -> <Object>
  def marshal_clone
    Marshal.load(Marshal.dump(self))
  end unless method_defined?(:marshal_clone)

  ##
  # to_bool -> Boolean
  def to_bool
    !!self
  end unless method_defined?(:to_bool)

  alias :deep_clone :marshal_clone unless method_defined?(:deep_clone)

end
MACL.register('macl/core/object', '1.3.0')