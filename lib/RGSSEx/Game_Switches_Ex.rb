# ╒╕ ♥                                                        Game_Switches ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Switches
  def on?(id)
    !!self[id]
  end
  def off?(id)
    !self[id]
  end
  def toggle(id)
    self[id] = !self[id]
  end
end