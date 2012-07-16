#-apndmacro _imported_
#-inject gen_scr_imported 'Archijust', '0x10001'
#-end:
#-inject gen_module_header 'MACL::Mixin::Archijust'
module MACL
  module Mixin
    module Archijust
      def define_as hash
        hash.each_pair do |k,v| define_method k do v end end
      end
      # // Update on change
      def define_uoc *syms
        syms.each do |sym|
          alias_method "set_#{sym}", "#{sym}="
          module_eval %Q(def #{sym}= n; set_#{sym} n if @#{sym} != n end)
        end
      end
      def define_clamp_writer hash
        hash.each_pair do |k,v|
          module_eval %Q(def #{k}= n; @#{k} = n.clamp(#{v[0]},#{v[1]}) end)
        end
      end
      # // stuff! and stuff
      def define_exfunc sym,&func
        str = sym.to_s+'!'
        define_method str,&func
        define_method sym do |*args,&block| dup.__send__(str,*args,&block) end
      end
    end
  end
end