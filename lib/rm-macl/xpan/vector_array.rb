#
# rm-macl/lib/rm-macl/xpan/vector_array.rb
#   by IceDragon
#   dc 24/03/2012
#   dc 24/03/2013
# vr 1.0.1
require 'rm-macl/macl-core'
require 'rm-macl/xpan/matrix'
module MACL
  class VectorArray < Matrix

    ##
    # initialize(int size)
    # initialize(int size, Numeric default)
    def initialize(size, default=0)
      super([size], default)
    end

  end
end
MACL.register('macl/xpan/vector_array', '1.1.0')