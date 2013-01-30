#-//06/02/2012
#-//06/02/2012
#-inject gen_class_header 'Game_Switches'
class Game
  class Switches

    # if the switch currently on?
    def on?(id)
      return !!self[id]
    end

    # if the switch currently off?
    def off?(id)
      return !self[id]
    end

    # toggle the switch state
    def toggle(id)
      self[id] = !self[id]
    end

  end
end
