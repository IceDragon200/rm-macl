#
# rm-macl/lib/rm-macl/xpan/easer.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class Easer

    @@easers = {}

    ##
    # _ease(t, st, ch, d)
    #   note that all _ease code was created and provided by CaptainJet,
    #   unless stated otherwise
    def _ease(t, st, ch, d=1.0)
      ch + st
    end

    ##
    # ease(Float t, Numeric st, Numeric et, Float d)
    def ease(t, st, et, d=1.0, *args)
      # BUG Certain easers will return a OutOfRange Float value at 0.0 time
      #     for now, the start value will be returned for 0.0 time
      return st if t == 0
      self._ease(t, st, et - st, d, *args)
    end

    def self.register(sym, neaser=self)
      nm = self.name.gsub("MACL::Easer::", "")
      define_method(:name) { nm }
      define_method(:symbol) { sym }
      @@easers[sym] = self.new
    end

    def self.easers
      @@easers
    end

    def self.get_easer(sym)
      @@easers[sym]
    end

    def self.[](sym)
      @@easers[sym]
    end

    def self.has_easer?(sym)
      @@easers.key?(sym)
    end

    def self.easer
      @_easer ||= new
    end

    def self.ease(*args)
      easer.ease(*args)
    end

  end
end

##
# Most Easer functions where written by UziMonkey <michael.c.morin@gmail.com>
# These Easer functions are taken from Robert Penner's Easing function
# they where moved to there respective Easing classes by IceDragon
# Easer::Null was written by IceDragon
require 'rm-macl/xpan/easer/back'
require 'rm-macl/xpan/easer/quad'
require 'rm-macl/xpan/easer/null'
require 'rm-macl/xpan/easer/elastic'
require 'rm-macl/xpan/easer/expo'
require 'rm-macl/xpan/easer/cubic'
require 'rm-macl/xpan/easer/linear'
require 'rm-macl/xpan/easer/quart'
require 'rm-macl/xpan/easer/bounce'
require 'rm-macl/xpan/easer/circ'
require 'rm-macl/xpan/easer/sine'
require 'rm-macl/xpan/easer/quint'
require 'rm-macl/xpan/easer/back-in'
require 'rm-macl/xpan/easer/back-inout'
require 'rm-macl/xpan/easer/back-out'
require 'rm-macl/xpan/easer/bounce-in'
require 'rm-macl/xpan/easer/bounce-inout'
require 'rm-macl/xpan/easer/bounce-out'
require 'rm-macl/xpan/easer/circ-in'
require 'rm-macl/xpan/easer/circ-inout'
require 'rm-macl/xpan/easer/circ-out'
require 'rm-macl/xpan/easer/cubic-in'
require 'rm-macl/xpan/easer/cubic-inout'
require 'rm-macl/xpan/easer/cubic-out'
require 'rm-macl/xpan/easer/elastic-in'
require 'rm-macl/xpan/easer/elastic-out'
require 'rm-macl/xpan/easer/expo-in'
require 'rm-macl/xpan/easer/expo-inout'
require 'rm-macl/xpan/easer/expo-out'
require 'rm-macl/xpan/easer/null-in'
require 'rm-macl/xpan/easer/null-out'
require 'rm-macl/xpan/easer/quad-in'
require 'rm-macl/xpan/easer/quad-inout'
require 'rm-macl/xpan/easer/quad-out'
require 'rm-macl/xpan/easer/quart-in'
require 'rm-macl/xpan/easer/quart-inout'
require 'rm-macl/xpan/easer/quart-out'
require 'rm-macl/xpan/easer/quint-in'
require 'rm-macl/xpan/easer/quint-inout'
require 'rm-macl/xpan/easer/quint-out'
require 'rm-macl/xpan/easer/sine-in'
require 'rm-macl/xpan/easer/sine-inout'
require 'rm-macl/xpan/easer/sine-out'
MACL.register('macl/xpan/easer', '2.1.0')