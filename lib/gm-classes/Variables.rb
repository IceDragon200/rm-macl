#
# RGSS3-MACL/lib/gm-classes/Variables.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 16/05/2013
class Game
  class Variables

    VERSION = "2.0.0".freeze
    SIZE = 5000

    ##
    # initialize
    def initialize
      @data = Array.new(SIZE, false)
    end

    ##
    # on_change
    def on_change
      # variable set callback
    end

    ##
    # [](Integer id)
    def [](id)
      @data[id]
    end

    ##
    # []=(Integer id, Integer n)
    def []=(id, n)
      @data[id] = n
      on_change
    end

    ##
    # on?(Integer id)
    #   is the switch currently on?
    def zero?(id)
      self[id] == 0
    end

  end
end
