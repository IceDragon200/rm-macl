#
# RGSS3-MACL/lib/xpan-lib/vector.rb
#   by IceDragon
#   dc 01/04/2013
#   dm 01/04/2013
dir = File.dirname(__FILE__)
%w(vector vectori vectorf Tool).each do |fn|
  require File.join(dir, 'vector', fn)
end
