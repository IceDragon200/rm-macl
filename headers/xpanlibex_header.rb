#-// eXpansion Library Header
────────────────────────────────────────────────────────────────────────────────
eXpansion Library
────────────────────────────────────────────────────────────────────────────────
  ♥ Point
    .new(x,y), .[x,y]
      ● Parameters 
          Integer x, y
      ● Return
          Point
    set
      ● Parameters 
          Integer x, y
      ● Return
          <self>
    to_a
      ● Return
          Numeric[x, y]
    to_s
      ● Return
          String
    to_hsh
      ● Return
          Hash[:x,:y]
    hash
      ● Return
          Integer
  ♥ Chitat
    .new(open_tag,close_tag)
      ● Parameters 
          Regexp open_tag, close_tag
      ● Return
          Chitat
    mk_and_set_tag(str)      
      ● Parameters 
          String str
      ● Return
          <self>
    parse_str(str)
      ● Parameters 
          String str
      ● Return
          String[]