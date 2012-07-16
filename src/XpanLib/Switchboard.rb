#-apndmacro _imported_
#-inject gen_scr_imported 'Switchboard', '0x10000'
#-end:
#-inject gen_class_header 'MACL::Switchboard'
module MACL
  class Switchboard
    def initialize init_count=0
      @data = {}
      @func = {}
      init_count.downto(0) do |i|
        @data[i] = false
      end
    end
    def set_switch key,n
      @data[key] = !!n
    end
    def add_switch key,&func
      @data[key] = false
      @func[key] = func
    end
    def toggle key
      @data[key] = !@data[key]
    end
    def toggle_all
      @data.each do |(k,v)| @data[k] = !v end
    end
    def get_state n=true
      if block_given?
        @data.each do |(k,v)| yield k if v == n end
      else
        @data.select do |(k,v)| v == n end
      end
    end
  end
end