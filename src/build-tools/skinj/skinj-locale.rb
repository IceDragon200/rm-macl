=begin
  
  skinj/skinj_locale.rb
  by IceDragon
  dc 22/10/2012
  dm 22/10/2012

=end
##
#  Module Skinj::Locale
#
class Skinj
  module Locale
    CMD_HELP = %Q(
/*        
  Skinj - Command Line 
  CMD Version #{Skinj::CommandLine::CMD_SKINJ_VERSION}
  SKJ Version #{Skinj::SKINJ_VERSION}
  */

HELP
  COMMANDS:
    --incur
      Enable INCUR replacement mode

    --edos
      Enabled EDOS style replacement mode

    --mode 
    --mode file
    --mode dir    
      Changing the Skinj mode to single file, or directory processing
      By default, the mode is set to single file handling

    --src <filename/directory>
      Sets the source filename or directory to be processed

    --dest <filename/directory>
      Sets the destination/target filename or directory for processing

    --syntax <filename>
      Changes the default Syntax system for Skinj

  HOW TO USE
    skinj -mode file -src my_code.rb -dest distribution.rb
    skinj -mode dir --incur -src my_codes -dest dist_codes   
)

  end
end
