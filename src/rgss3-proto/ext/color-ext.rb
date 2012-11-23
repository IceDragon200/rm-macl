#
# ext/color-ext.rb
#
class Color

  def to_gosu
    Gosu::Color.rgba(red, green, blue, alpha)
  end

end
