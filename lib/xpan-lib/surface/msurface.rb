#
# RGSS3-MACL/lib/xpan-lib/surface/msurface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 2.0.1
require File.join(File.dirname(__FILE__), '..', 'archijust')

module MACL
module Mixin
module Surface

  extend MACL::Mixin::Archijust

  attr_accessor :freeform

  # it is advised that x2, y2 be overwritten for your special class
  def x2
    self.x + self.width
  end

  def y2
    self.y + self.height
  end

  def x2=(n)
    unless @freeform
      self.x = n - self.width
    else
      self.width = n - self.x
    end
  end

  def y2=(n)
    unless @freeform
      self.y = n - self.height
    else
      self.height = n - self.y
    end
  end

  def cx
    x + width / 2
  end

  def cy
    y + height / 2
  end

  def cx=(x)
    self.x = x - self.width / 2
  end

  def cy=(y)
    self.y = y - self.height / 2
  end

  def hset(hash)
    x, y, x2, y2, w, h = hash.get_values(:x, :y, :x2, :y2, :width, :height)

    self.x, self.y          = x || self.x, y || self.y
    self.x2, self.y2        = x2 || self.x2, y2 || self.y2
    self.width, self.height = w || self.width, h || self.height

    return self
  end

end
end
end
