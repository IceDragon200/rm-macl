#
# RGSS3-MACL/lib/xpan-lib/grid.rb
#   by IceDragon
#   dc 30/03/2012
#   dm 30/03/2013
dir = File.dirname(__FILE__)
%w(grid2 grid3).each do |fn|
  require File.join(dir, 'grid', fn)
end

MACL::Grid = MACL::Grid2
