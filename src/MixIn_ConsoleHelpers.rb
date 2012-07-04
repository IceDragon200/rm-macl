#==============================================================================#
# ? MixIn_ConsoleHelpers
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 01/14/2012
# // • Data Modified : 01/14/2012
# // • Version       : 1.0
#==============================================================================#
module MixIn_ConsoleHelpers
  def _command_regex size=1
    prm = '[ ](.*)' * [(size-1), 0].max
    prm += '[ ](.*)' if size > 0
    return /#{yield}#{prm}/i
  end
  def yn_confirm n=""
    loop do
      puts "Are you sure!?"
      puts "(Y|N) maybe?"
      print "<#{n}@> "
      case gets.upcase.chomp
        when "Y", "YES"  ; return true
        when "N", "NO"   ; return false
        when "M", "MAYBE"; puts "D: Make up your mind already!"
      end
    end
  end
end
#=¦==========================================================================¦=#
#                           // ? End of File ? //                              #
#=¦==========================================================================¦=#