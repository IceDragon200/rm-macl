#-inject gen_scr_imported_ww 'Archijust', '0x10001'
#-inject gen_module_header 'Archijust'
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
    end
  end
end