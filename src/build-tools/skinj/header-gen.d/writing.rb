#encoding:UTF-8
#
# src/build-tools/skinj/header-gen.d/writing.rb
#
module Skinj_Gen

  # // Story Writing
  def wrgen_chapter(num, name, chapter_nm="Chapter")
    str ="# ╒╕ ■ %068s ╒╕"
    str+="# └┴────────────────────────────────────────────────────────────────────────┴┘"
    str % format("%s %s - %s", chapter_nm, num, name)
  end

end
