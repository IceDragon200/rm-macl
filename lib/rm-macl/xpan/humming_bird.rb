#
# rm-macl/lib/rm-macl/xpan/hummingbird.rb
#   by IceDragon
require 'rm-macl/macl-core'
module MACL #:nodoc:
  class HummingBird

    # \\   # escape \

    ## Locale
    # \l   # locale
    # \ly  # locale-system
    # \ls  # locale-switch   # also known as switch-name
    # \lv  # locale-variable # also known as variable-name
    # \lw  # locale-word     # also known as word-name
    # \lpb # locale-param-basic
    # \lps # locale-param-special
    # \lpx # locale-param-x

    ## Font
    # \fd  # font-default
    # \fn  # font-name
    # \fs  # font-size
    # \fb  # font-bold
    # \fi  # font-italic
    # \fu  # font-underline
    # \fo  # font-outline
    # \fh  # font-shadow
    # \fc  # font-color
    # \fhc # font-shadow-color
    # \foc # font-outline-color

    ## Name
    # \na  # name-actor
    # \ne  # name-enemy
    # \ni  # name-item
    # \ns  # name-skill
    # \nw  # name-weapon
    # \nr  # name-armor
    # \nm  # name-map
    # \np  # name-party

    ## Party
    # \pln # party-leader-name
    # \pmc # party-member-count
    # \pmn # party-member-name
    # \pg  # party-gold
    # \ps  # party-steps

    ## sYstem
    # \yv  # system-variable
    # \ys  # system-switch
    # \yw  # system-word
    # \yt  # system-time
    # \yth # system-time-hour
    # \ytm # system-time-minute
    # \yts # system-time-second
    # \ypt # system-playtime

    ## Icon
    # \i   # icon
    # \ia  # icon-actor
    # \ie  # icon-enemy
    # \ii  # icon-item
    # \is  # icon-skill
    # \iw  # icon-weapon
    # \ir  # icon-armor
    # \im  # icon-map
    # \ip  # icon-party
    # \ipb # icon-param-basic
    # \ips # icon-param-special
    # \ipx # icon-param-x

    ## Timing
    # \t   # time
    # \ts  # time-short
    # \tl  # time-long
    # \tw  # time-wait
    # \!   # wait-for-user

    ## Text-Control
    # \>   # fast-print-on
    # \<   # fast-print-off
    # \^   # new-page

    ## Window
    # \wx  # window-x
    # \wy  # window-y
    # \ww  # window-width
    # \wh  # window-height
    # \wn  # window-namebox
    # \wg  # window-goldbox

  end
end
MACL.register('macl/xpan/humming_bird', '0.0.0')