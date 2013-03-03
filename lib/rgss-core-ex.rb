#
# RGSS3-MACL/lib/rgss-core-ex.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
dir = File.dirname(__FILE__)
require File.join(dir, 'macl-core')
%w(audio bitmap color font graphics input
   rect sprite table tone window
  ).each do |fn|
  require File.join(dir, 'rgss-core-ex', fn)
end
