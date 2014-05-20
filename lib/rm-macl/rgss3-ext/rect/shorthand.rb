#
# rm-macl/lib/rm-macl/rgss3-ext/rect/cast.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Rect

  alias :w :width
  alias :h :height

  alias :w= :width=
  alias :h= :height=

end
MACL.register('macl/rgss3-ext/rect/shorthand', '1.0.0')