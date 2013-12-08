#
# rm-macl/lib/rm-macl/xpan/size.rb
#
require 'rm-macl/macl-core'
require 'rm-macl/core_ext/module'
require 'rm-macl/mixin/archijust'
require 'rm-macl/mixin/mathable'
require 'rm-macl/xpan/type-stub'
module MACL
  class Size

    extend MACL::Mixin::Archijust
    include MACL::Mixin::Mathable

    class << self
      private :new
    end

  end
end
MACL.register('macl/xpan/size/size', '1.2.0')