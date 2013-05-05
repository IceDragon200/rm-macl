#
# RGSS3-MACL/lib/xpan-lib/tween.rb
#   by CaptainJet
#   mb IceDragon (mistdragon100@gmail.com)
#   dc 15/12/2011
#   dm 06/12/2012
# vr 1.1.1
#
# // Special Credits To:
# Robert Penner (For whatever reason Jet mentioned him)
# UziMonkey (For whatever reason Jet mentioned him)
# CaptainJet (For original script)
# Modularize, rewrite, and new by IceDragon

dir = File.dirname(__FILE__)
require File.join(dir, 'easer')
%w(tween tweenerror multi seqr osc tween_struct tool).each do |fn|
  require File.join(dir, 'tween', fn)
end
