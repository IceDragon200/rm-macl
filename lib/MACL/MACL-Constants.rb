module MACL
  module Constants
    ANCHOR = {}
    # // Standard
    ANCHOR[:all]          = 0
    ANCHOR[:null]         = 5
    ANCHOR[:horizontal]   = 11
    ANCHOR[:vertical]     = 12
    # // Extended
    ANCHOR[:left]         = 4
    ANCHOR[:right]        = 6
    ANCHOR[:top]          = 8
    ANCHOR[:bottom]       = 2
    # // Full
    ANCHOR[:top_left]     = 7
    ANCHOR[:top_right]    = 9
    ANCHOR[:bottom_left]  = 1
    ANCHOR[:bottom_right] = 3
  end
end