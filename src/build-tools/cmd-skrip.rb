#encoding:UTF-8
=begin
  
  build_tools/cmd_skrip.rb
  by IceDragon
  dc 22/10/2012
  dm 22/10/2012

=end
Encoding.default_external = "UTF-8"

require_relative 'skrip/skrip_locale.rb'

##
# Module Skrip::CommandLine
#
class Skrip
  module CommandLine

    SKRIP_VERSION = "0x10000"

    def self.get_help_string()
      puts Skrip::Locale::CMD_HELP
    end

  end
end

include Skrip::CommandLine

##
# main(String[] argsv)
#
def main(argsv)

  if !argsv || argsv.empty?
    puts Skrip::CommandLine.get_help_string
    return false
  end

  require_relative "skrip/skrip.rb"

end

begin
  main(ARGV.dup);
rescue(Exception) => ex
  raise ex
end
