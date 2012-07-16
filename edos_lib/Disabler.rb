#===============================================================================
# ? SDK
#===============================================================================
# TODO: Make more stuff.
#===============================================================================
 
module SDK
  
  #--------------------------------------------------------------------------
  # Labels of scripts to be skipped over during runtime.
  # Should match the same label given in the script editor.
  #--------------------------------------------------------------------------
  DISABLED_CODES = ["Jet - Hello World Test"]
  
  #--------------------------------------------------------------------------
  # Eliminate any disabled scripts to prevent evaluation of them
  #--------------------------------------------------------------------------
  DISABLED_CODES.each {|code_name|
    $RGSS_SCRIPTS.each_with_index {|def_script, index|
      if def_script[1] == code_name
        $RGSS_SCRIPTS[index] = nil
      end
    }
  }
  $RGSS_SCRIPTS.compact! if $RGSS_SCRIPTS.include?(nil)
 
end