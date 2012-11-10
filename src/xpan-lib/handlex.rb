#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Handlex', '0x10000'
#-end:
#-inject gen_class_header 'MACL::Handlex'
module MACL
  class Handlex
    def initialize
      @handler = []
    end 
    def call sym,*args,&block
      @handler[sym].call *args,&block if @handler.has_key?(sym)
    end
    def set sym,func
      @handler[sym] = func
    end
    def unset sym
      @handler.delete(sym)
    end  
    def clear
      @handler.clear
    end
  end
end