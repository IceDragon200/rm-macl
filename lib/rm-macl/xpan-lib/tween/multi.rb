#
# RGSS3-MACL/lib/xpan-lib/multi.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'tween')

module MACL
class Tween
class Multi

  attr_reader :tweeners

  def initialize *tweensets
    set *tweensets
  end

  def set *tweensets
    clear
    tweensets.each do |tset|
      add_tween *tset
    end
  end

  def done?
    return @tweeners.all? { |t| t.done? }
  end

  def clear
    @tweeners = []
  end

  def tweener index
    @tweeners[index]
  end

  def tweener_value index, vindex
    @tweeners[index].value vindex
  end

  def tweener_values index
    @tweeners[index].values
  end

  def add_tween *args
    @tweeners << Tween.new(*args)
  end

  def reset
    @tweeners.each do |t| t.reset_time ; end
  end

  def value index
    @tweeners[index].value
  end

  def values
    @tweeners.map do |t| t.value ; end
  end

  def all_values
    @tweeners.map { |t| t.values ; }.flatten
  end

  def update
    @tweeners.each do |t| t.update ; end
  end

end
end
end
