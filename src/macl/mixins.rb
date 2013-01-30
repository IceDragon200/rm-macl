#-inject gen_module_header 'MACL::Mixin'
#-define xINSTALLED_NOTESCAN_:
module MACL
  module Mixin
#-inject gen_module_header 'BaseItem_NoteScan'
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

    module Surface
    end

  end
end
