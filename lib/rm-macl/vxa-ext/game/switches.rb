#
# rm-macl/lib/rm-macl/vxa-ext/game/switches.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Game_Switches

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
    # switch set callback
    $game_map.need_refresh = true # default action
  end

  ##
  # [](Integer id)
  def [](id)
    @data[id]
  end

  ##
  # []=(Integer id, Boolean n)
  def []=(id, n)
    @data[id] = !!n
    on_change
  end

  ##
  # on?(Integer id)
  #   is the switch currently on?
  def on?(id)
    self[id] == true
  end

  ##
  # off?(Integer id)
  #   is the switch currently off?
  def off?(id)
    self[id] == false
  end

  ##
  # toggle(Integer id)
  #   toggle the switches state
  def toggle(id)
    self[id] = !self[id]
  end

  def name(id)
    $data_system.switches[id]
  end

  private :on_change

end
MACL.register('macl/vxa/game/switches', '1.2.0')