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

  OBJ_TYPE_CHAR = {
    "class"  => "♥",
    "module" => "■",
    "x"      => "●",
    ""       => "•",
  }

  def gen_script_header_wotail hsh
    # :generic
    script_type   = hsh[:type]
    script_name   = hsh[:name]
    script_author = hsh[:author]
    script_dc     = hsh[:dc]
    script_dm     = hsh[:dm]
    script_version= hsh[:version]
    script_dsf    = hsh[:dsf]
    # :jstyle
    script_path   = hsh[:path]

    style = hsh[:style] || :jstyle #:classic

    spacers = []
    spacers[0] = gen_spacer

    str = ""

    case style
    when :classic
      str += "=begin\n"
      str += " %s %s\n" % [OBJ_TYPE_CHAR[script_type], script_name]
      str += spacers[0]
      str += " • Created By    : %s\n" % script_author
      str += " • Data Created  : %s\n" % script_dc
      str += " • Data Modified : %s\n" % script_dm
      str += " • Version       : %s\n" % script_version
      str += " • Designed For  : %s\n" % script_dsf if script_dsf
    when :jstyle
      str += "=begin\n"
      str += "  \n"
      str += "  #{script_path}\n" if script_path
      str += "  %s %s\n" % [OBJ_TYPE_CHAR[script_type], script_name]
      str += "  by #{script_author}\n"
      str += "  dc #{script_dc}\n"
      str += "  dm #{script_dm}\n"
      str += "  vr #{script_version}\n"
      str += "  dsf #{script_dsf}\n" if script_dsf
      str += "  \n"
    end
    str
  end

  def gen_function_info hsh
    func_name = hsh[:name]                   # String
    func_parameters = hsh[:parameters]       # String[]
    func_param_types = hsh[:parameter_types] # Hash<String name, String type> 
    func_return = hsh[:returns]              # String[]
    func_return_types = hsh[:return_types]   # Hash<String name, String type> 

    str = ""
    str += "##\n"
    str += "#  #{func_name}(#{func_parameters.join(', ')})\n"
    str += "#    #{func_parameters.size > 1 ? 'Parameters' : 'Parameter'}\n"
    func_parameters.each do |param|
      str += "#      #{func_param_types[param]} #{param}\n"
    end
    str += "#\n"  
    if func_return
      str += "#    #{func_return.size > 1 ? 'Returns' : 'Return'}\n"
      func_return.each do |param|
        str += "#      #{func_return_types[param]} #{param}\n"
      end
    end
    str += "#\n"  
    str  
  end

  def gen_script_header hsh
    gen_script_header_wotail(hsh) + gen_script_header_tail(hsh)
  end

  def gen_spacer size=78
    " "+(?─*size)+" \n"
  end

  def gen_script_header_tail hsh={}
    style = hsh[:style] || :classic
    case style
    when :classic
      str = gen_spacer 
    when :jstyle
      str = " "
    end
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
    str % [sym, name]
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
