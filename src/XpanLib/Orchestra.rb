#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Orchestra', '0x10000'
#-end:
#-inject gen_class_header 'MACL::Orchestra'
module MACL
  class Orchestra
    def initialize
      @switchboard = MACL::Switchboard.new 10
      @funcs = {}
    end
    def update
      @switchboard.get_state true do |id|
        @funcs[id].call if @funcs.has_key?(id)
      end
    end
  end
end