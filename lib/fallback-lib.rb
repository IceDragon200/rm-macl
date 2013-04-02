#
# RGSS3-MACL/lib/fallback-lib.rb
#   by IceDragon
#   dc 01/04/2013
#   dc 01/04/2013
# vr 1.0.0
module MACL

  FALLBACK_LOADED = true

module Fallback

  VERSION = "1.0.0".freeze

end
end

dir = File.dirname(__FILE__)
%w(rect color tone).each do |fn|
  require File.join(dir, 'fallback-lib', fn)
end

Rect  = MACL::Fallback::Rect unless defined?(Rect)
Color = MACL::Fallback::Color unless defined?(Color)
Tone  = MACL::Fallback::Tone unless defined?(Tone)
