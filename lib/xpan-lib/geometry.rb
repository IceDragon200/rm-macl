#
# RGSS3-MACL/lib/xpan-lib/geometry.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.1.1
module MACL
  module Geometry

    VERSION = '1.1.1'.freeze

  end
end

dir = File.dirname(__FILE__)
%w(point path line angle rectangle square oval polygon circle).each do |fn|
  require File.join(dir, 'geometry', fn)
end
