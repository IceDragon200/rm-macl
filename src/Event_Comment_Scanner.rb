#===============================================================================
# ? Game_Event
#===============================================================================
# TODO: Make more stuff.
#===============================================================================
class Game_Event
  
  #--------------------------------------------------------------------------
  # Scan's the event's commencts for 'term'. May be Regexp or String.
  #--------------------------------------------------------------------------
  def search_comments(term)
    return false if @list.nil? || @list.size <= 0
    @list.each {|item|
      if [108, 408].include?(item.code)
        return true if item.parameters[0].scan(term)
      end
    }
    return false
  end
end