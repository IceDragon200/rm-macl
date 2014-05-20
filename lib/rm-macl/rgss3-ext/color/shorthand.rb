#
# rm-macl/lib/rm-macl/rgss3-ext/color/shorthand.rb
#   by IceDragon
require 'rm-macl/macl-core'

class Color

  alias :r :red
  alias :g :green
  alias :b :blue
  alias :a :alpha

  alias :r= :red=
  alias :g= :green=
  alias :b= :blue=
  alias :a= :alpha=

end

MACL.register('macl/rgss3-ext/color/shorthand', '1.0.0')