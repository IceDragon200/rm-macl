#
# RGSS3-MACL/lib/xpan-lib/tween.rb
#
# original by CaptainJet
# mb IceDragon
# dc 15/12/2011
# dm 06/12/2012
# vr 1.11
#
# // Special Credits To:
# Robert Penner (For whatever reason Jet mentioned him)
# UziMonkey (For whatever reason Jet mentioned him)
# CaptainJet (For original script)
# Modularize, rewrite, and new by IceDragon

dir = File.dirname(__FILE__)
%w(tween tweenerror easers easers-ex
   multi seqr osc tween_struct tool).each do |fn|
  require File.join(dir, 'tween', fn)
end
