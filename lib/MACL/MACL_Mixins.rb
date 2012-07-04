# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
#-define xNOTESCAN:
module MACL::Mixin
# ╒╕ ■                                                    BaseItem_NoteScan ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  module BaseItem_NoteScan
    private
    def pre_note_scan
      @note.each_line { |line| parse_note_line(line, :pre) }
    end
    def note_scan
      @note.each_line { |line| parse_note_line(line, :mid) }
    end
    def post_note_scan
      @note.each_line { |line| parse_note_line(line, :post) }
    end
    def parse_note_line line, section
    end
    public
    def do_note_scan
      pre_note_scan
      note_scan
      post_note_scan
    end
  end
end
# ╒╕ ■                                                                  RPG ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module RPG
# ╒╕ ♥                                                             BaseItem ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class BaseItem
    include MACL::Mixin::BaseItem_NoteScan
  end
# ╒╕ ♥                                                                  Map ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
  class Map
    include MACL::Mixin::BaseItem_NoteScan
  end
end