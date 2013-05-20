#
# RGSS3-MACL/lib/gm-classes/Switches.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 16/05/2013
class Game
  class Switches

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
      # switch set callback
    end

    ##
    # [](Integer id)
    def [](id)
      @data[id]
    end

    ##
    # []=(Integer id, Boolean n)
    def []=(id, n)
      @data[id] = !!n
      on_change
    end

    ##
    # on?(Integer id)
    #   is the switch currently on?
    def on?(id)
      self[id] == true
    end

    ##
    # off?(Integer id)
    #   is the switch currently off?
    def off?(id)
      self[id] == false
    end

    ##
    # toggle(Integer id)
    #   toggle the switches state
    def toggle(id)
      self[id] = !self[id]
    end

  end
end
