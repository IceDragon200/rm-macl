# ╒╕ ♥                                                       Game::Switches ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game::Switches
  def on? id 
    !!self[id]
  end
  def off? id
    !self[id]
  end
  def toggle id
    self[id] = !self[id]
  end
end