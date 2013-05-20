#
# RGSS3-MACL/lib/xpan-lib/pos/Pos2.rb
#   by IceDragon
#   dc 05/05/2013
#   dm 05/05/2013
# vr 1.0.0
module MACL
class Pos2 < Vector2F

  class Axis2 < Pos2
  end

  attr_reader :orientation # int orientation

  ##
  # initialize(Numeric x, Numeric y, Axis o)
  def initialize(x=0.0, y=0.0, o=UNKNOWN)
    super(x, y)
    self.orientation = o
  end

  ##
  # orientation=(Fixnum o)
  # orientation=(Axis o)
  def orientation=(o)
    @orientation = o.is_a?(Fixnum) ? o : o.orientation
  end

  ##
  # move_straight(Numeric step, Vector3f d)
  def move_straight(step, d)
    self.add!(d * step)
  end

  ##
  # move_north(Numeric step)
  def move_north(step)
    move_straight(step, NORTH)
  end

  ##
  # move_south(Numeric step)
  def move_south(step)
    move_straight(step, SOUTH)
  end

  ##
  # move_east(Numeric step)
  def move_east(step)
    move_straight(step, EAST)
  end

  ##
  # move_west(Numeric step)
  def move_west(step)
    move_straight(step, WEST)
  end

  ##
  # move_forward(Numeric step)
  def move_forward(step)
    move_straight(step, get_axis)
  end

  ##
  # move_backward(Numeric step)
  def move_backward(step)
    move_straight(step, get_axisi)
  end

  ##
  # get_axis
  def get_axis
    AXES[@orientation]
  end

  ##
  # get_axisi
  def get_axisi
    AXESI[@orientation]
  end

  ##
  # ::get_orientation(Numeric step)
  def self.get_orientation(id)
    id = id.orientation if id.kind_of?(Axis)
    if (id >= 0 && id < VALID_AXES.size)
      return VALID_AXES[id]
    end
    return UNKNOWN
  end

  ##
  EAST    = Axis2.new( 1.0, 0.0, 4).freeze
  WEST    = Axis2.new(-1.0, 0.0, 3).freeze
  SOUTH   = Axis2.new( 0.0, 1.0, 2).freeze
  NORTH   = Axis2.new( 0.0,-1.0, 1).freeze
  UNKNOWN = Axis2.new( 0.0, 0.0, 6).freeze

  # All possible Axes
  AXES  = [NORTH, SOUTH, WEST, EAST, UNKNOWN].freeze
  # Inversed Axes
  AXESI = [SOUTH, NORTH, EAST, WEST, UNKNOWN].freeze

  VALID_AXES  = AXES[0, 4].freeze
  VALID_AXESI = AXESI[0, 4].freeze

  alias :axis :get_axis

end
end
