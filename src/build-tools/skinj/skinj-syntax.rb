=begin

  skinj/skinj_syntax.rb
  Skinj Default Syntax
  by IceDragon
  dc 22/10/2012
  dm 22/10/2012

=end
##
#  Module Skinj::Constants
# 
class Skinj
  module Constants
    # // Base
    REGEXP_ASMB_COM   = /\#\-(\d+)?(.+)/i
    # // Commands
    REGEXP_COMMENT    = /\A\/\/(.*)/i
    REGEXP_INDENT     = /\Aindent\s([+-])?(\d+)/i
    REGEXP_EVAL       = /\Aeval\s(.+)/i
    REGEXP_LOG        = /\Alog:/i
    REGEXP_INCLUDE    = /\Ainclude\s(.+)/i
    REGEXP_INJECT     = /\Ainject\s(.+)/i
    REGEXP_INSERT     = /\Ainsert\s(.+)/i
    REGEXP_SWITCH     = /\Aswitch\s(\w+):(ON|TRUE|OFF|FALSE|TOGGLE|FLIP)/i
    REGEXP_UNDEF      = /\A(?:undefine|undef)\s(\w+)/i
    REGEXP_DEFINE     = /\Adefine\s(?<key>\w+)(?:\s*(?<param>[\#\&\|]{0,3})\=\s*(?<value>.+)|:?)/i
    REGEXP_IF         = /\A(?<cond>(?:if|unless))(?<mod>(?:not|n))?(?<def>def)?\s(?<value>.+)/i
    REGEXP_ELSE       = /\Aelse\:/i
    REGEXP_END        = /\Aend(?:if|unless|\:)/i
    REGEXP_SKIP       = /\Askip(?:\s(\d+)|\:)/i
    REGEXP_SKIPX      = /\Askip\:/i
    REGEXP_ASMSHOW    = /\Aasmshow\s(.+)/i
    REGEXP_WAIT       = /\Await\s(\d+.\d+)/i
    REGEXP_PRINT      = /\Aprint\s(.+)/i
    REGEXP_LABEL      = /\A(?:label|marker)\s(\w+)/i
    REGEXP_JUMP       = /\A(?:jumpto|jump)\s(?:(?<index>\d+|(?<label>\w+)))/i
    REGEXP_MACRO      = /\A(?:replay|macro)\s(\w+)/i
    REGEXP_MACRO_REC  = /\A(?:record|rec|append|apnd)(?:macro|mcr)?\s(\w+)/i
    REGEXP_MACRO_STOP = /\A(?:stop|stp)(?:macro|mcr)?\s(\w+)/i
    REGEXP_MACRO_CLEAR= /\A(?:clear|clr)(?:macro|mcr)\s(\w+)/i
    REGEXP_TO_FILE    = /\A(?:build|save|assemble)\sto\s(?<filename>.+)/i
    FOLD_OPN = [REGEXP_IF, REGEXP_SKIPX, REGEXP_MACRO_REC]
    #/\A(?:(?:if|unless)(?:not|n)?def|skip|(?:rec|apnd|record|append)(?:macro|mcr))/i
  end
end
