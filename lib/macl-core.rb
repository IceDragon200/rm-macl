#
# RGSS3-MACL/lib/macl-core.rb
#   by IceDragon (mistdragon100@gmail.com)
#   dc 03/03/2013
#   dm 19/06/2013
# MACL core module, containing version information and a few assistant functions
module MACL

  VERSION = '2.3.0'.freeze

  ##
  # ::frame_rate
  #   Can be overloaded by project, if they have a different way of handling
  #   the frame_rate
  def self.frame_rate
    defined?(Graphics) ? Graphics.frame_rate : 60
  end

end
