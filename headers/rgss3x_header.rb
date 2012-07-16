#-// RGSS Xpansion Header
────────────────────────────────────────────────────────────────────────────────
RGSSEx Expansion
────────────────────────────────────────────────────────────────────────────────
  ♥ Color, ♥ Tone
    to_a
      ● Return
          Numeric[red, green, blue, alpha]
    to_a_na, to_a_ng
      ● Return
          Numeric[red, green, blue]
    to_hex
      ● Return
          String hex
    to_flash
      ● Return
          Integer
    to_color
      ● Return
          Color
    to_tone
      ● Return
          Tone
    rgb_sym
      ● Return
          Symbol[:red, :green, :blue]
  ♥ Font
    to_hsh, marshal_dump
      ● Return
          Hash[:color, :out_color, :name, :size, :bold, :italic, :shadow, :outline]
    marshal_load(font_hash)
      ● Parameters 
          Hash font_hash
  ♥ Rect
    to_a
      ● Return
          Numeric[x, y, width, height]
    to_va
      ● Return
          Numeric[x, y, vwidth, vheight]
    to_rect
      ● Return
          Rect
  ♥ RPG::BaseItem
  ♥ RPG::Event::Page
    select_commands(*codes)
      ● Parameters 
          Integer[]
      ● Return
          RPG::Event::Page[]
    comments
      ● Return
          RPG::EventCommand[]
    comments_a
      ● Return
          String[]
  ♥ Game_Switches
    on?(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean
    off?(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean      
    toggle(id)
      ● Parameters 
          Integer id
      ● Return
          Boolean      