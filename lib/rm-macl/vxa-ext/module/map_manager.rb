#
# rm-macl/lib/rm-macl/vxa-ext/module/map_manager.rb
#   by IceDragon
module MapManager

  @@map_data_path    = 'Data/'
  @@map_filename_spf = 'Map%03d'
  @@map_filename_ext = '.rvdata2'

  @@maps = {}

  ##
  # ::on_load_map(RPG::Map map)
  #   callback hook for load_map, action takes place after the map has
  #   be loaded, to make changes
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
    on_load_map(map)
    return map
  end

  ##
  # ::get_map(int id)
  def self.get_map(id)
    @@maps[id] = load_map(id) unless @@maps.key?(id)
    return @@maps[id]
  end

  ##
  # ::clear
  def self.clear
    @@maps.clear
    return self
  end

end
MACL.register('macl/vxa/module/map_manager', '1.1.2')