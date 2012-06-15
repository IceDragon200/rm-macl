# // RGSS3 Prototype
require_relative '_rgss3_prototype_lite'
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
