#
# rm-macl/lib/rm-macl/vxa-ext/game/map.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Game_Map

  # do before the map is loaded
  def pre_load_map
    # insert logic here
  end

  def load_map
    @map = MapManager.get_map(@map_id).deep_clone
  end

  # do after the map has been loaded
  def post_load_map
    # insert logic here
  end

  # @overwrite
  def setup(map_id)
    @map_id = map_id
    pre_load_map
    load_map
    post_load_map
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
  end

end
MACL.register('macl/vxa/game/map', '1.1.0')