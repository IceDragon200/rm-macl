#encoding:UTF-8
=begin
 ──────────────────────────────────────────────────────────────────────────────
 Header Gen
   Script Related
     gen_script_header_wotail(hsh)
     gen_script_header(hsh)
     gen_script_des(name)
     gen_function_des(name)
     gen_class_header(name)
     gen_module_header(name)
     gen_script_footer
   Writing Related
     wrgen_chapter(chapter_num, name, chapter_sfm_name)
 ──────────────────────────────────────────────────────────────────────────────
=end
Encoding.default_external = Encoding.default_internal = "UTF-8"

module Skinj_Gen
  
end

require_relative 'header-gen.d/default.rb'
require_relative 'header-gen.d/writing.rb'
