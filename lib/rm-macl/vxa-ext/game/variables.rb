#
# rm-macl/lib/rm-macl/vxa-ext/game/variables.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Game_Variables

  include Enumerable

  SIZE = 5000

  ##
  # initialize
  def initialize
    @data = Array.new(SIZE, false)
  end

  ##
  #
  def each
    return to_enum(__method__) unless block_given?
    @data.each_with_index { |x, i| yield i, x }
  end

  ##
  # on_change
  def on_change(id)
    # variable set callback
    $game_map.need_refresh = true # default action
  end

  ##
  # [](Integer id)
  def [](id)
    @data[id]
  end

  ##
  # []=(Integer id, Integer n)
  def []=(id, n)
    @data[id] = n
    on_change
  end

  ##
  # on?(Integer id)
  #   is the switch currently on?
  def zero?(id)
    self[id] == 0
  end

  def name(id)
    $data_system.variables[id]
  end

  private :on_change

end
MACL.register('macl/vxa/game/variables', '1.2.0')