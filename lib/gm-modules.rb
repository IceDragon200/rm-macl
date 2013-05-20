#
# RGSS3-MACL/lib/gm-modules.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
dir = File.dirname(__FILE__)
require File.join(dir, 'macl-core')
%w(map-manager scene-manager).each do |fn|
  require File.join(dir, 'gm-modules', fn)
end
