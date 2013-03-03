#
# RGSS3-MACL/lib/gm-classes/game-switches.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.0.0
class Game
  class Switches

    ##
    # on?(int id)
    #   is the switch currently on?
    def on?(id)
      return !!self[id]
    end

    ##
    # off?(int id)
    #   is the switch currently off?
    def off?(id)
      return !self[id]
    end

    ##
    # toggle(int id)
    #   toggle the switches state
    def toggle(id)
      self[id] = !self[id]
    end

  end
end
