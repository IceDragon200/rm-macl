#==============================================================================
# ** Lemony's Universal Notefields Anglebrackets Reader (LUNAR v.2.1)
#------------------------------------------------------------------------------
# - Adds a new method that gets info from notefield and returns a hash with it.
#==============================================================================
module Lemony
  #--------------------------------------------------------------------------
  # * Get Tags
  # - Scriptname = String containing keywords for tag searching.
  # - Use Hash   = Returns a hash or the equivalent [key, [value]] array
  #--------------------------------------------------------------------------
  def get_tags(scriptname, use_hash = true)
    # If string includes the given tag
    if (@note =~ /<#{scriptname}(.*)#{scriptname}>/m) && !$game_system.nil?
      # Gets what it is actually inside the tags
      p = @note.match(/<#{scriptname}(.*)#{scriptname}>/m)[1].strip
      # Separates each key with its value and deletes empty string
      v = p.split(':') ; v.shift
      # Creates container variable and container variables for keys and values
      container = use_hash ? {} : []
      # Iterates through each line & deletes weird characters
      v.each_with_index {|str, i| str.strip!
      # Sets temporal variable for value and array value
      pv, int = str.scan(/= ([^<>]*)/imu).flatten[0], []
      # Fills the temporal array variable
      pv.split(?,).each_with_index {|v| int.push(v.to_i != 0 ? v.to_i : v)}
      # Creates container
      key = str.scan(/([^<>]*)=/imu).flatten[0].to_sym
      value = pv.include?(',') ? int : pv.to_i != 0 ? pv.to_i : pv
      container[key] = value if use_hash
      container[i] = [key, value] if !use_hash}
      # Returns the finnished product
      container
    end
  end
end
class RPG::BaseItem ; include Lemony ; end
class RPG::Map    ; include Lemony ; end