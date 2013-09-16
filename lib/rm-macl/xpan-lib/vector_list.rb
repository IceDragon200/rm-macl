#
# RGSS3-MACL/lib/xpan-lib/vectorlist.rb
#   by IceDragon
#   dc 24/03/2012
#   dc 24/03/2013
# vr 1.0.1
require 'rm-macl/xpan-lib/matrix'
module MACL
  class VectorList < Matrix

    ##
    # initialize(int size)
    # initialize(int size, Numeric default)
    def initialize(size, default=0)
      super([size], default)
    end

  end
end
MACL.register('macl/xpan/vector_list', '3.0.0')