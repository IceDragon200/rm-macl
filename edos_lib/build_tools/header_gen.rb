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
Encoding.default_external = "UTF-8"
Encoding.default_internal = "UTF-8"
module Skinj_Gen
  def gen_script_header_wotail hsh
    script_type   = hsh[:type]
    script_name   = hsh[:name]
    script_author = hsh[:author]
    script_dc     = hsh[:dc]
    script_dm     = hsh[:dm]
    script_version= hsh[:version]
    script_dsf    = hsh[:dsf]
    spacers = []
    spacers[0] = gen_spacer
    str = ""
    str += "=begin\n"
    str += " %s %s\n" % [script_type == "class" ? "♥" : "■", script_name]
    str += spacers[0]
    str += " • Created By    : %s\n" % script_author
    str += " • Data Created  : %s\n" % script_dc
    str += " • Data Modified : %s\n" % script_dm
    str += " • Version       : %s\n" % script_version
    str += " • Designed For  : %s\n" % script_dsf if script_dsf
    str
  end
  def gen_script_header hsh
    gen_script_header_wotail(hsh)+gen_script_header_tail
  end
  def gen_spacer size=78
    " "+(?─*size)+" \n"
  end
  def gen_script_header_tail
    str = gen_spacer
    str+"=end\n"
  end
  def gen_script_des name
    name = ?● + " " + name unless [?●,?•,?♥,?■].any? { |s| name.start_with?(s) }
    t="─"*name.size
    str=" ─┐ %s ┌─" % name
    str+= "─"*(79-str.size)+"\n"
    str+="  └─#{t}─┘ \n"
    str
  end
  def gen_script_des_end name
    name = ?● + " " + name unless [?●,?•,?♥,?■].any? { |s| name.start_with?(s) }
    t="─"*name.size
    str="  ┌─#{t}─┐ \n"
    str=" ─┘ %s └─" % name
    str+= "─"*(79-str.size)+"\n"
    str
  end
  def gen_function_des name
    name = ?● + " " + name unless [?●,?•,?♥,?■].any? { |s| name.start_with?(s) }
    t="─"*name.size
    str  ="# ─┤ %s ├─" % name
    str += "─"*(78-str.size)+"\n"
    str
  end
  def gen_sym_header sym,name
    str ="# ╒╕ %s %068s ╒╕\n"
    str+="# └┴────────────────────────────────────────────────────────────────────────┴┘"
    str % [sym,name]
  end
  def gen_class_header name
    gen_sym_header ?♥, name
  end
  def gen_module_header name
    gen_sym_header ?■, name
  end
  def gen_script_footer
    str ="# ┌┬────────────────────────────────────────────────────────────────────────┬┐\n"
    str+="# ╘╛ ● End of File ●                                                        ╘╛"
    str
  end
  def gen_scr_imported name, value
    %Q(($imported||={})['%s']=%s) % [name,value]
  end
  def gen_scr_import_warn name, value=nil
    %Q(warn '%1$s is already imported' if ($imported||={})['%1$s']) % name
  end
  def gen_scr_imported_ww name, value
    str = gen_scr_import_warn name, value
    str += "\n" + gen_scr_imported(name, value)
    str
  end
  alias gen_script_import gen_scr_imported
  # // Story Writing
  def wrgen_chapter num,name,chapter_nm="Chapter"
    str ="# ╒╕ ■ %068s ╒╕"
    str+="# └┴────────────────────────────────────────────────────────────────────────┴┘"
    str % format("%s %s - %s", chapter_nm, num, name)
  end
end