#-inject gen_module_header 'MACL'
class << MACL
  def mk_null_str(size=256)
    string = "\0" * size
  end
  @w32_funcs = {
    'GPPSA' => Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l'),
    'GetClientRect' => Win32API.new('user32', 'GetClientRect', 'lp', 'i'),
    #'GetWindowRect' => Win32API.new('user32', 'GetWindowRect', 'lp', 'i'),
    'FindWindowEx'  => Win32API.new('user32','FindWindowEx','llpp','l')
  }
  def get_client
    string = mk_null_str(256)
    @w32_funcs['GPPSA'].call('Game','Title','',string,255,".\\Game.ini")
    @w32_funcs['FindWindowEx'].call(0, 0, nil, string.delete!("\0"))
  end
  private :get_client
  def client_rect
    rect = [0, 0, 0, 0].pack('l4')
    @w32_funcs['GetClientRect'].call(client, rect)
    Rect.new(*rect.unpack('l4').map!(&:to_i))
  end
  def client
    @client ||= get_client
  end
end