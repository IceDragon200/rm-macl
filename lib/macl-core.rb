#
# RGSS3-MACL/lib/macl-core.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 05/05/2013
module MACL

  VERSION = '2.2.1.000'.freeze

  ##
  # ::frame_rate
  #   Can be overloaded by project, if they have a different way of handling
  #   the frame_rate
  def self.frame_rate
    defined?(Graphics) ? Graphics.frame_rate : 60
  end

end
