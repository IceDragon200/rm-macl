#===============================================================================
# ? SDK
#===============================================================================
# TODO: Make more stuff.
#===============================================================================

module SDK
  
  string = "\0" * 256 
  ini = Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l')
  ini.call('Game', 'Title', '', string, 255, ".\\Game.ini")
  win = Win32API.new('user32','FindWindowEx','llpp','l')
  @handle = win.call(0, 0, nil, string.delete!("\0"))
  GetClientRect = Win32API.new('user32', 'GetClientRect', 'lp', 'i')
  GetWindowRect = Win32API.new('user32', 'GetWindowRect', 'lp', 'i')
  
  module_function
  
  #--------------------------------------------------------------------------
  # Obtain a Rect that represents the Window's screen position
  #--------------------------------------------------------------------------
  def client_rect
    final_rect = []
    rect = [0, 0, 0, 0].pack('l4')
    GetWindowRect.call(@handle, rect)
    final_rect.concat(rect.unpack('l4')[0..1])
    rect = [0, 0, 0, 0].pack('l4')
    GetClientRect.call(@handle, rect)
    final_rect.concat(rect.unpack('l4')[2..3])
    Rect.new(*final_rect)
  end
  
  #--------------------------------------------------------------------------
  # Public Handle Accessor
  #--------------------------------------------------------------------------
  def handle
    @handle
  end
end