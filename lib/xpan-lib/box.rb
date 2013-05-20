#
# RGSS3-MACL/lib/xpan-lib/box.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.1.1
dir = File.dirname(__FILE__)
%w(box box2 box3).each do |fn|
  require File.join(dir, 'box', fn)
end

