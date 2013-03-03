#
# RGSS3-MACL/lib/gm-classes/game-map.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
dir = File.dirname(__FILE__)
require File.join(dir, '..', 'std-lib-ex', 'object')
require File.join(dir, '..', 'gm-modules', 'map-manager')

class Game
  class Map

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
end
