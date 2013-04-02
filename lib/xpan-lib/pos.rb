#
# RGSS3-MACL/lib/xpan-lib/pos.rb
#   by IceDragon
#   dc 01/04/2012
#   dc 01/04/2013
# vr 1.0.0

require File.join(File.dirname(__FILE__), 'vector')

module MACL
class Pos3 < Vector3f

  attr_accessor :orientation

  def initialize(x, y, z, o=UNKNOWN)
    super(x, y, z)
    @orientation = o.kind_of?(Pos3) ? o.orientation : o
  end

  ##
  # move_straight(Numeric step, Vector3f d)
  def move_straight(step, d)
    self.add!(d * step)
  end

  def move_up(step)
    move_straight(step, UP)
  end

  def move_down(step)
    move_straight(step, DOWN)
  end

  def move_north(step)
    move_straight(step, NORTH)
  end

  def move_south(step)
    move_straight(step, SOUTH)
  end

  def move_east(step)
    move_straight(step, EAST)
  end

  def move_west(step)
    move_straight(step, WEST)
  end

  def move_forward(step)
    move_straight(step, AXES[@orientation])
  end

  def move_backward(step)
    move_straight(step, AXESI[@orientation])
  end

  def get_rotation(axis)
    Pos3.get_orientation(ROTATION_MATRIX[axis.orientation][orientation])
  end

  def self.get_orientation(id)
    id = id.orientation if id.kind_of?(MACL::Vector)
    if (id >= 0 && id < VALID_AXES.size)
      return VALID_AXES[id]
    end
    return UNKNOWN
  end

  ##
  # Based on the Minecraft Forge net.minecraftforge.common.ForgeDirection
  # http://www.minecraftforge.net/
  EAST    = new( 1.0, 0.0, 0.0, 5).freeze
  WEST    = new(-1.0, 0.0, 0.0, 4).freeze
  UP      = new( 0.0, 1.0, 0.0, 1).freeze
  DOWN    = new( 0.0,-1.0, 0.0, 0).freeze
  SOUTH   = new( 0.0, 0.0, 1.0, 3).freeze
  NORTH   = new( 0.0, 0.0,-1.0, 2).freeze
  UNKNOWN = new( 0.0, 0.0, 0.0, 6).freeze

  # All possible Axes
  AXES  = [DOWN, UP, NORTH, SOUTH, WEST, EAST, UNKNOWN].freeze
  # Inversed Axes
  AXESI = [UP, DOWN, SOUTH, NORTH, EAST, WEST, UNKNOWN].freeze

  VALID_AXES  = AXES[0, 6].freeze
  VALID_AXESI = AXESI[0, 6].freeze

  # Left hand rule rotation matrix for all possible axes of rotation
  ROTATION_MATRIX = [
    [0, 1, 4, 5, 3, 2, 6],
    [0, 1, 5, 4, 2, 3, 6],
    [5, 4, 2, 3, 0, 1, 6],
    [4, 5, 2, 3, 1, 0, 6],
    [2, 3, 1, 0, 4, 5, 6],
    [3, 2, 0, 1, 4, 5, 6],
    [0, 1, 2, 3, 4, 5, 6]
  ].map! { |a| a.map! { |i| AXES[i] }.freeze }.freeze

end
end
