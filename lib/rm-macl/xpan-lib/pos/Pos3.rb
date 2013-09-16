#
# RGSS3-MACL/lib/xpan-lib/pos/Pos3.rb
#   by IceDragon
#   dc 01/04/2012
#   dm 05/05/2013
# vr 1.0.1
module MACL
  class Pos3 < Vector3F

    class Axis3 < Pos3
    end

    attr_reader :orientation # int orientation

    ##
    # initialize(Numeric x, Numeric y, Numeric z, Axis o)
    def initialize(x=0.0, y=0.0, z=0.0, o=UNKNOWN)
      super(x, y, z)
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
    # move_up(Numeric step)
    def move_up(step)
      move_straight(step, UP)
    end

    ##
    # move_down(Numeric step)
    def move_down(step)
      move_straight(step, DOWN)
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
    # get_rotation(Axis axis)
    def get_rotation(axis)
      Axis3.get_orientation(ROTATION_MATRIX[axis.orientation][orientation])
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
    # Based on the Minecraft Forge net.minecraftforge.common.ForgeDirection
    # http://www.minecraftforge.net/
    EAST    = Axis3.new( 1.0, 0.0, 0.0, 5).freeze
    WEST    = Axis3.new(-1.0, 0.0, 0.0, 4).freeze
    UP      = Axis3.new( 0.0, 1.0, 0.0, 1).freeze
    DOWN    = Axis3.new( 0.0,-1.0, 0.0, 0).freeze
    SOUTH   = Axis3.new( 0.0, 0.0, 1.0, 3).freeze
    NORTH   = Axis3.new( 0.0, 0.0,-1.0, 2).freeze
    UNKNOWN = Axis3.new( 0.0, 0.0, 0.0, 6).freeze

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

    alias :axis :get_axis

  end
end
