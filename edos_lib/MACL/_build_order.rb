# ╒╕ ■                                                                 MACL ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  @@initialized = []
  @@inits = []
  def self.init
    constants.collect(&method(:const_get)).each(&method(:invoke_init))
    run_init # // Extended scripts
  end
  def self.invoke_init nodule
    nodule.init if nodule.respond_to? :init
  end
  def self.add_init sym,func
    @@inits << [sym,func]
  end
  def self.run_init
    @@inits.each do |(sym,func)|
      p "%s was already initialized" if @@initialized.include? sym
      begin
        func.call 
      rescue Exception => ex
        p 'MACL: %s failed to load:' % sym.to_s
        p ex
        next
      end
      @@initialized << sym
    end
  end
  module Mixin
  end
end
module MACL
  module Constants
    ANCHOR = {
    # // Standard
      null: 0,
      center: 5,
      horizontal: 11, # // Horizontal
      horz: 11,
      horz0: 12, # // Horizontal Top
      horz1: 13, # // Horizontal Mid
      horz2: 14, # // Horizontal Bottom
      # // Vertical
      vertical: 15, # // Vertical
      vert: 15,
      vert0: 16, # // Vertical Top
      vert1: 17, # // Vertical Mid
      vert2: 18, # // Vertical Bottom
      # // Based on NUMPAD
      left: 4,
      right: 6,
      top: 8,
      up: 8,
      bottom: 2,
      down: 2,
      top_left: 7,
      top_right: 9,
      bottom_left: 1,
      bottom_right: 3
    }
  end
end
# ╒╕ ■                                                          MACL::Mixin ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
module MACL
  module Mixin
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
    module TableExpansion 
    end
    module Surface
    end
  end
end