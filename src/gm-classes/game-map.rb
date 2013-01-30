#
# src/gm-classes/game-map.rb
#
class Game
  class Map

    # do before the map is loaded
    def pre_load_map
      # insert logic here
    end

    # do after the map has been loaded
    def post_load_map
      # insert logic here
    end

    # @overwrite
    def setup map_id
      @map_id = map_id
      pre_load_map
      @map = MapManager.load_map(@map_id)
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
