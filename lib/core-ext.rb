#
# RGSS3-MACL/lib/core-ext.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
dir = File.dirname(__FILE__)
require File.join(dir, 'macl-core')
%w(Array Hash Kernel MatchData Module Numeric Object String).each do |fn|
  require File.join(dir, 'core-ext', fn)
end
