#
# RGSS3-MACL/lib/xpan-lib/vectorlist.rb
#   by IceDragon
#   dc 24/03/2012
#   dc 24/03/2013
# vr 1.0.0
require File.join(File.dirname(__FILE__), 'matrix')

module MACL
class VectorList < MACL::Matrix

  def initialize(default=0)
    super(1, default)
  end

end
end
