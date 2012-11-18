#!usr/bin/ruby
#encoding:UTF-8
=begin

  src/build_tools/cmd-skinj.rb
  by IceDragon
  dc 12/10/2012
  dm 12/10/2012
  vr 0x10200

  Change Log
    12/10/2012
      Combined script_assembler.rb and asm_folder.rb to form cmd_skinj.rb

=end

require_relative "skinj/header-gen"

##
# Class Skinj 
#
class Skinj

  DEFAULT_SYNTAX_FILENAME = File.join(File.dirname(__FILE__), 'skinj/skinj-syntax.rb')

  include Skinj_Gen

  module CommandLine

    SKINJ_VERSION = "0x14001"

    require_relative "skinj/skinj-locale"
    
    MODE_FILE = 0
    MODE_DIR  = 1

    def self.skinj_folder(source, target, settings)
      Dir.mkdir(target) unless File.exist?(target)
      files = Dir.entries(source) - [".", ".."]
      #puts "Files #{source}"
      #puts files
      files.each do |sf|
        bsn = File.basename(sf)
        pth = "#{source}/#{bsn}"
        trg = "#{target}/#{bsn}"
        if File.directory?(pth)
          puts "Entering new directory %s" % trg
          unless File.exist?(trg)
            puts "Making Directory: %s" % trg
            Dir.mkdir(trg)
          end
          skinj_folder(pth, trg, settings)
        else
          skinj_file(pth, trg, settings)
        end
      end
    #rescue Exception => ex
    #  Skinj.debug_puts 'Error ocurred while Skinj-ing directory' 
    #  p ex
    end

    def self.skinj_file(src, dest, settings)
      File.open(dest, 'w+') do |f|
        puts "=> Making #{dest}"
        str         = File.read(src)
        indent      = settings[:def_indent]
        definitions = settings[:def_default].clone
        switches    = settings[:def_switches].clone

        new_settings = {
          indent: indent,
          definitions: definitions,
          switches: switches,    
          source: src
        }

        result = Skinj.parse(str, new_settings).assemble
        f.write(result)
      end
      return true
    #rescue Exception => ex
    #  Skinj.debug_puts 'Error ocurred while Skinj-ing %s' % pth
    #  p ex
    #  return false
    end

    def self.get_help_string
      puts Skinj::Locale::CMD_HELP
    end

    def self.print_settings(settings)
      mode_str = case settings[:mode]
                 when MODE_FILE
                    "File"
                 when MODE_DIR
                    "Directory"
                 end
      puts %Q(
/*
  Skinj - Command Line 
  Version #{SKINJ_VERSION}     
  */

Running with following parameters:
  MODE : #{mode_str}
  Source #{mode_str} : #{settings[:src]}        
  Destination #{mode_str} : #{settings[:dest]}

  Default Settings:
    Indent : #{settings[:def_indent]}
    Definitions : 
      #{settings[:def_default]}
    Switches : 
      #{settings[:def_switches]}
)
    end

  end
end

include Skinj::CommandLine

#
# main(String[] argsv)
#
def main(argsv)

  if !argsv || argsv.empty?
    puts Skinj::CommandLine.get_help_string
    return false
  end

  settings = {
    :mode => MODE_FILE,
    :src  => Dir.getwd,
    :dest => nil,

    :def_indent => 0,

    :def_default  => {
      "ASMxROOT" => Dir.getwd, # // Current Working Directory : 1.3
      "__#CD__" => Dir.getwd # // Current Working Directory : 1.4
    },
    :def_switches => {
      "INCUR" => false
    }
  }

  syntax_filename = Skinj::DEFAULT_SYNTAX_FILENAME

  while(arg = argsv.shift)
    case arg
    when '--help', '-h'
      puts Skinj::CommandLine.get_help_string
      return false
    # // Enabled EDOS mode, replaces all Game_ with Game::  
    when '--edos', '-e'
      settings[:def_default]['Game_']   = 'Game::'
      settings[:def_default]['Sprite_'] = 'Sprite::'
      settings[:def_default]['Window_'] = 'Window::'
      settings[:def_default]['Scene_']  = 'Scene::'
    # // Enable incur replacement mode  
    when '--incur', '-i'
      settings[:def_switches]['INCUR'] = true
    # // Skinj Processing Modes
    when '/mode', '--mode', '-m'
      case(n = argsv.shift)
      # // Process directories
      when 'dir'
        settings[:mode] = MODE_DIR
      # // Process single file  
      when 'file'
        settings[:mode] = MODE_FILE
      else
        raise(ArgumentError, "Invalid Skinj mode: #{n}")
      end  
    # // Set the source directory/file  
    when '/src', '--src', '-s'
      settings[:src] = argsv.shift
    # // Set the destination/target directory/file  
    when '/dest', '--dest', '-d'
      settings[:dest] = argsv.shift
    # // Change Syntax File :D  
    when '/syntax', '--syntax', '-x'
      syntax_filename = argsv.shift
    else
      raise(ArgumentError, "Invalid Command: #{arg}")
    end
  end

  ##
  # optimization: quick launch
  #
  require File.expand_path(syntax_filename)
  require_relative 'skinj/skinj-main'

  Skinj::CommandLine.print_settings(settings)

  time_then = Time.now

  settings[:src] = File.expand_path(settings[:src])
  settings[:dest] = File.expand_path(settings[:dest])

  case settings[:mode]
  when MODE_DIR
    Skinj::CommandLine.skinj_folder(settings[:src], settings[:dest], settings)
  when MODE_FILE
    Skinj::CommandLine.skinj_file(settings[:src], settings[:dest], settings)
  end

  time_elapsed = Time.now - time_then

  time_str = "#{time_elapsed.round(2).to_s} sec(s)"

  Skinj.debug_puts("Operation Completed in #{time_str}")

  return true
end

begin
  main(ARGV.dup);
rescue(Exception) => ex
  #puts ex.backtrace
  raise ex
end
