#-inject gen_module_header 'MACL::Dyna'
#-define xINSTALLED_DYNA_:
module MACL
  module Dyna
    @@w32_funcs = {}
    def self.init
      @@w32_funcs.merge(
        'GPPSA'         => Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l'),
        'GetClientRect' => Win32API.new('user32', 'GetClientRect', 'lp', 'i'),
        #'GetWindowRect' => Win32API.new('user32', 'GetWindowRect', 'lp', 'i'),
        'FindWindowEx'  => Win32API.new('user32','FindWindowEx','llpp','l')
      )
    end
    def self.mk_null_str(size=256)
      string = "\0" * size
    end
    def self.get_client
      string = mk_null_str(256)
      @w32_funcs['GPPSA'].call('Game','Title','',string,255,".\\Game.ini")
      @w32_funcs['FindWindowEx'].call(0,0,nil,string.delete!("\0"))
    end
    def self.client_rect
      rect = [0, 0, 0, 0].pack('l4')
      @w32_funcs['GetClientRect'].call(client, rect)
      Rect.new(*rect.unpack('l4').map!(&:to_i))
    end
    def self.client
      @client ||= get_client
    end
  end
end  