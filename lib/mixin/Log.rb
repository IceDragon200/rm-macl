#
# RGSS3-MACL/lib/mixin/Log.rb
#   by IceDragon
#   dc 18/05/2013
#   dc 18/05/2013
# vr 1.0.0

module MACL
module Mixin
module Log

  VERSION = "1.0.0".freeze

  attr_accessor :log # IO

  def try_log
    yield(@log) if @log
  end

end
end
end
