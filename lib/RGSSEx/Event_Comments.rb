# ╒╕ ♥                                                     RPG::Event::Page ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class RPG::Event::Page
  COMMENT_CODES = [108,408]
  def select_commands(*codes)
    @list.select{|c|codes.include?(c.code)}
  end
  def comments
    select_commands *COMMENT_CODES
  end
  def comments_a
    comments.map!(&:parameters).flatten!
  end
end
# ╒╕ ♥                                                           Game_Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comment_a
    @page.comment_a
  end
end