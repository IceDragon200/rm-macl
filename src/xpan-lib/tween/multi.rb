#
# src/xpan-lib/tween/multi.rb
#
class MACL::Tween::Multi

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
    @tweeners.collect do |t| t.value ; end
  end

  def all_values
    @tweeners.collect { |t| t.values ; }.flatten
  end

  def update
    @tweeners.each do |t| t.update ; end
  end

end
