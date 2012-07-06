# ╒╕ ♥                                                     RPG::Event::Page ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
  class Event
    class Page
      COMMENT_CODES = [108,408]
      def select_commands *codes
        @list.select do |c| codes.include?(c.code) end
      end
      def comments
        select_commands *COMMENT_CODES
      end
      def comments_a
        comments.map(&:parameters).flatten
      end
    end
  end
end
# ╒╕ ♥                                                           Game_Event ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Game_Event
  def comments_a
    @page.comments_a
  end
end