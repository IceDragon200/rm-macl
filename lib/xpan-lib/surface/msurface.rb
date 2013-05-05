#
# RGSS3-MACL/lib/xpan-lib/surface/msurface.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 24/04/2013
# vr 2.2.1
require File.join(File.dirname(__FILE__), '..', 'archijust')

module MACL
module Mixin
module Surface

  extend MACL::Mixin::Archijust

  attr_accessor :freeform

  ##
  # freeform_do
  #   The Surface will enter freeform editing based on the given toggle state
  #   within the block
  #   the original state is restored once the block is completed
  def freeform_do(toggle=true)
    return to_enum(:freeform_do) unless block_given?
    old_freeform = @freeform
    @freeform = toggle
    yield self
    @freeform = old_freeform
  end

  # it is advised that x2, y2 be overwritten for your special class
  def x2
    self.x + self.width
  end

  def y2
    self.y + self.height
  end

  def x2=(n)
    if @freeform
      self.width = n - self.x
    else
      self.x = n - self.width
    end
  end

  def y2=(n)
    if @freeform
      self.height = n - self.y
    else
      self.y = n - self.height
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

  ##
  # anchor_point(anchor) -> Point
  #   Calculates and returns the "Anchor" Point (x, y[, z]) Surface
  def anchor_point(anchor)
    anchor_ids = MACL::Surface::Tool.anchor_to_ids(anchor)

    x = case anchor_ids[0]
    when MACL::Surface::Tool::ID_NULL then self.x
    when MACL::Surface::Tool::ID_MIN  then self.x
    when MACL::Surface::Tool::ID_MID  then self.cx
    when MACL::Surface::Tool::ID_MAX  then self.x2
    end

    y = case anchor_ids[1]
    when MACL::Surface::Tool::ID_NULL then self.y
    when MACL::Surface::Tool::ID_MIN  then self.y
    when MACL::Surface::Tool::ID_MID  then self.cy
    when MACL::Surface::Tool::ID_MAX  then self.y2
    end

    if surface_3d?
      z = case anchor_ids[3]
      when MACL::Surface::Tool::ID_NULL then self.z
      when MACL::Surface::Tool::ID_MIN  then self.z
      when MACL::Surface::Tool::ID_MID  then self.cz
      when MACL::Surface::Tool::ID_MAX  then self.z2
      end
      return MACL::Point3d.new(x, y, z)
    else
      return MACL::Point2d.new(x, y)
    end
  end

  ##
  # points -> | if surface_3d? Array<Point3d>
  # points -> | else           Array<Point2d>
  #   using right hand rule
  def points
    if surface_3d?
      [MACL::Point3d.new(x2, y, z),
       MACL::Point3d.new(x2, y2, z),
       MACL::Point3d.new(x2, y2, z2),
       MACL::Point3d.new(x, y2, z2),
       MACL::Point3d.new(x, y, z2),
       MACL::Point3d.new(x, y, z)]
    else
      [MACL::Point2d.new(x2, y),
       MACL::Point2d.new(x2, y2),
       MACL::Point2d.new(x, y2),
       MACL::Point2d.new(x, y)]
    end
  end

end
end
end
