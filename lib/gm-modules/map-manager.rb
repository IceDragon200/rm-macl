#
# RGSS3-MACL/lib/gm-modules/map-manager.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.1
module MapManager

  @@map_data_path    = 'data/'
  @@map_filename_spf = 'Map%03d'
  @@map_filename_ext = '.rvdata2'

  @@maps = {}

  ##
  # ::on_map_load(RPG::Map map)
  def self.on_map_load(map)
    # do with map
  end

  ##
  # ::load_map(int id)
  def self.load_map(id)
    filename = File.join(
                    @@map_data_path,
                    (@@map_filename_spf % id) + @@map_filename_ext)
    map = load_data(filename)
    on_map_load(map)
    return map
  end

  ##
  # ::get_map(int id)
  def self.get_map(id)
    @@maps[id] = load_map(id) unless @@maps.has_key?(id)
    return @@maps[id]
  end

  def self.clear
    @@maps.clear
    return self
  end

end
