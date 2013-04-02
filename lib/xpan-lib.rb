#
# RGSS3-MACL/lib/xpan-lib.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
dir = File.dirname(__FILE__)
require File.join(dir, 'macl-core')
%w(archijust
   blaz box
   cacher colorvector cube
   easer
   fifo
   geometry grid
   interpolate
   matrix morph
   notereader
   pallete parcer point pos
   sequen surface
   task tween tween2
   vector vectorlist
  ).each do |fn|
  require File.join(dir, 'xpan-lib', fn)
end
