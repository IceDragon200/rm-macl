# // RGSS3 Prototype
require 'win32api'
require 'zlib'
require 'dl'
module Graphics
end
module Input
end
module RPG
  class BaseItem
  end
  class UsableItem < BaseItem
  end
  class Skill < UsableItem
  end
  class Item < UsableItem
  end
  class State < BaseItem
  end
  class Actor < BaseItem
  end
  class Enemy < BaseItem
  end
  class Class < BaseItem
  end
  class EquipItem < BaseItem
  end
  class Weapon < EquipItem
  end
  class Armor < EquipItem
  end
  class Map 
  end
  class Event
  end
end
class Rect
end
class Viewport
end
class Window
end
class Sprite
end
class Plane
end
class Bitmap
end
class Font
end