=begin

=end
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
     wrgen_chapter
 ──────────────────────────────────────────────────────────────────────────────
=end
Encoding.default_external = "UTF-8"
def gen_script_header_wotail(hsh)
  script_type   = hsh[:type]
  script_name   = hsh[:name]
  script_author = hsh[:author]
  script_dc     = hsh[:dc]
  script_dm     = hsh[:dm]
  script_version= hsh[:version]
  script_dsf    = hsh[:dsf]
  spacers = []
  spacers[0] = " "+("─"*78)+" \n" #?# + (?= * 78) + '#\n'
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
def gen_script_header(hsh)
  gen_script_header_wotail(hsh)+"=end\n"
end
def gen_script_des(name)
  name = ?● + " " + name unless [?●,?•,?♥,?■].any? { |s| name.start_with?(s) }
  t="─"*name.size
  str=" ─┐ %s ┌─" % name
  str+= "─"*(79-str.size)+"\n"
  str+="  └─#{t}─┘ \n"
  str
end
def gen_function_des(name)
  name = ?● + " " + name unless [?●,?•,?♥,?■].any? { |s| name.start_with?(s) }
  t="─"*name.size
  str="# ─┤ %s ├─" % name
  str+= "─"*(78-str.size)+"\n"
  str
end
def gen_class_header(name)
str=%Q(# ╒╕ ♥ %068s ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘)
  str%name
end
def gen_module_header(name)
str=%Q(# ╒╕ ■ %068s ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘)
  str%name
end
def gen_script_footer
%Q(# ┌┬────────────────────────────────────────────────────────────────────────┬┐
# ╘╛ ● End of File ●                                                        ╘╛)
end
# // Story Writing
def wrgen_chapter(num,name,chapter_nm="Chapter")
str=%Q(# ╒╕ ■ %068s ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘)
  str%format("%s %s - %s", chapter_nm, num, name)
end