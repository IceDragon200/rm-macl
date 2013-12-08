#
# rm-macl/lib/rm-macl/fallback.rb
#
require 'rm-macl/macl-core'
module MACL #:nodoc:
  module Fallback
  end
end

loaded = []
unless defined?(Rect)
  require 'rm-macl/fallback/rect'
  Rect   = MACL::Fallback::Rect
  loaded << :rect
end
unless defined?(Color)
  require 'rm-macl/fallback/color'
  Color  = MACL::Fallback::Color
  loaded << :color
end
unless defined?(Tone)
  require 'rm-macl/fallback/tone'
  Tone   = MACL::Fallback::Tone
  loaded << :tone
end
MACL.set_flag(:rgss_fallback, loaded)
MACL.register('macl/fallback', '2.0.0')