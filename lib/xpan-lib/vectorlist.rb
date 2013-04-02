#
# RGSS3-MACL/lib/xpan-lib/vectorlist.rb
#   by IceDragon
#   dc 24/03/2012
#   dc 24/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'matrix')

module MACL
class VectorList < Matrix

  def initialize(size, default=0)
    super([size], default)
  end

end
end
