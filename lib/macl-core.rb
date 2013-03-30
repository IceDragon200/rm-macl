#
# RGSS3-MACL/lib/macl-core.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 24/03/2013
module MACL

  VERSION = '2.1.1.000'.freeze

  def self.frame_rate
    defined?(Graphics) ? Graphics.frame_rate : 60
  end

end
