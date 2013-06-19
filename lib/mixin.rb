#
# RGSS3-MACL/lib/mixin.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 1.0.0
dir = File.dirname(__FILE__)
require File.join(dir, 'macl-core')
%w(log archijust callback color_math table_ex stack_element).each do |fn|
  require File.join(dir, 'mixin', fn)
end
