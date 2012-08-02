#-apndmacro _imported_
#-inject gen_scr_imported 'MACL::Orchestra', '0x10001'
#-end:
#-inject gen_class_header 'MACL::Orchestra'
module MACL
  class Orchestra
    attr_accessor :switchboard
    def initialize
      @switchboard = MACL::Switchboard.new 10
      @handlex     = MACL::Handlex.new
    end
    def update
      @switchboard.get_state true do |id|
        @handlex.call id 
      end
    end
  end
end