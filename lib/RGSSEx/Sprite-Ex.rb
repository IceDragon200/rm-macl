# ╒╕ ♥                                                               Sprite ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Sprite
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end