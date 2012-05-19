#==============================================================================#
# ■ GameManager (Main)
#==============================================================================#
# // • Created By    : IceDragon
# // • Data Created  : 12/27/2011
# // • Data Modified : 01/04/2012
# // • Version       : 1.0a
#==============================================================================#
# // This module handles the save location along with the achievements
#==============================================================================#
# ● Change Log
#     ♣ 12/27/2011 V1.0 
#     ♣ 01/04/2012 V1.0 
#     ♣ 02/02/2012 V1.0a 
#==============================================================================#
module GameManager
  raise "GameManager (Setup) is not installed" unless const_defined? :SETUP
  #--------------------------------------------------------------------------#
  # ♦ Constant(s)
  #--------------------------------------------------------------------------#  
  VERSION = "1.0a"
  MAIN_SAVE_LOCATION = ENV["USERPROFILE"].gsub(/\\/i, "/") + MAIN_FOLDER_NAME
  GAME_SAVE_LOCATION = MAIN_SAVE_LOCATION + "#{GAME_NAME}/"
  ACMT_SAVE_LOCATION = MAIN_SAVE_LOCATION 
  GMID_SAVE_LOCATION = MAIN_SAVE_LOCATION 
  GAME_SAVE_EXT = ".rvdata2"
  ACMT_SAVE_EXT = ".tfac"
  GMID_SAVE_EXT = ".tfac"
  GAME_SAVE_GLB = GAME_SAVE_LOCATION + "#{GAME_NAME}Save*" + GAME_SAVE_EXT
  GAME_SAVE_SPF = GAME_SAVE_LOCATION + "#{GAME_NAME}Save%02d" + GAME_SAVE_EXT
  GAME_CONFIG   = GAME_SAVE_LOCATION + "#{GAME_NAME}_config" + GAME_SAVE_EXT
  ACMT_SAVE     = ACMT_SAVE_LOCATION + "Achievements" + ACMT_SAVE_EXT
  GMID_SAVE     = GMID_SAVE_LOCATION + "GameIDs" + GMID_SAVE_EXT
  #--------------------------------------------------------------------------#
  # ♦ File Creation
  #--------------------------------------------------------------------------#    
  Dir.mkdir(MAIN_SAVE_LOCATION)    unless FileTest.exist?(MAIN_SAVE_LOCATION)
  Dir.mkdir(GAME_SAVE_LOCATION)    unless FileTest.exist?(GAME_SAVE_LOCATION)
  Dir.mkdir(ACMT_SAVE_LOCATION)    unless FileTest.exist?(ACMT_SAVE_LOCATION)
  Dir.mkdir(GMID_SAVE_LOCATION)    unless FileTest.exist?(GMID_SAVE_LOCATION)
  save_data(Hash.new, ACMT_SAVE)   unless FileTest.exist?(ACMT_SAVE)
  save_data(Hash.new, GMID_SAVE)   unless FileTest.exist?(GMID_SAVE)
  save_data(Hash.new, GAME_CONFIG) unless FileTest.exist?(GAME_CONFIG)
#==============================================================================#
# ♥ Achievement
#/============================================================================\#
# ● Explanation
#     Houses the data for an achievement
#\============================================================================/#
  class Achievement
    attr_accessor :code
    attr_accessor :name
    attr_accessor :description
    attr_accessor :gsym
    def initialize( code, name, description, gsym )
      @code        = code
      @name        = name
      @description = description
      @gsym        = gsym
    end 
  end  
  #--------------------------------------------------------------------------#
  # ■|► module-method :open_config
  #/------------------------------------------------------------------------\#
  # ● Yields
  #     Hash
  #\------------------------------------------------------------------------/#
  def self.open_config()
    save_data((yield load_data(GAME_CONFIG)), GAME_CONFIG)
  end  
  #--------------------------------------------------------------------------#
  # ■|► module-method :open_acmt
  #/------------------------------------------------------------------------\#
  # ● Yields
  #     Hash[game_id] = Code_Hash
  #\------------------------------------------------------------------------/#
  def self.open_acmt()
    hsh = load_data(ACMT_SAVE)
    yield hsh
    save_data(hsh, ACMT_SAVE)
  end  
  #--------------------------------------------------------------------------#
  # ■|● module-method :get_acmts_for
  #/------------------------------------------------------------------------\#
  # ● Yields
  #     Hash[code] = Achievement
  #\------------------------------------------------------------------------/#
  def self.get_acmts_for( game_id )
    open_acmt { |hsh| yield hsh[game_id] }
  end 
  #--------------------------------------------------------------------------#
  # ■|► module-method :edit_game_acmt_hash
  #/------------------------------------------------------------------------\#
  # ● Yields
  #     Hash[code] = Achievement
  #\------------------------------------------------------------------------/#
  def self.edit_game_acmt_hash()
    get_acmts_for( GAME_ID ) { |hsh| yield hsh }
  end 
  #--------------------------------------------------------------------------#
  # ■|► module-method :make_acmt
  #/------------------------------------------------------------------------\#
  # ● Returns
  #     [code(Integer), values(Array[string, string])]
  #\------------------------------------------------------------------------/#
  def self.make_acmt( code, name, description )
    return [code, name, description]
  end  
  #--------------------------------------------------------------------------#
  # ■|► module-method :add_acmts
  #/------------------------------------------------------------------------\#
  # ● Parameters
  #     [code(Integer), values(Array[string, string])], n, n, ....
  #\------------------------------------------------------------------------/#
  def self.add_acmts( *acs )
    acs.each { |aca| code, name, des = *aca
      ac = Achievement.new( code, name, des, GAME_SYM )
      edit_game_acmt_hash { |hsh| hsh[code] = ac } }
  end
  #--------------------------------------------------------------------------#
  # ■|● module-method :clear_acmts
  #--------------------------------------------------------------------------#
  def self.clear_acmts()
    edit_game_acmt_hash { |hsh| hsh.clear }
  end
  #--------------------------------------------------------------------------#
  # ■|● module-method :save_game_id
  #--------------------------------------------------------------------------#
  def self.save_game_id()
    hsh = load_data(GMID_SAVE)
    hsh[GAME_NAME] = GAME_ID  
    save_data(hsh, GMID_SAVE)
    @gm_game_ids = load_data(GMID_SAVE)
  end 
  #--------------------------------------------------------------------------#
  # ■|● module-method :init_acmt
  #--------------------------------------------------------------------------#
  def self.init_acmt()
    open_acmt { |hsh| hsh[GAME_ID] ||= {} }
  end  
  attr_reader :gm_game_ids
  module_function :gm_game_ids
  init_acmt()
  save_game_id()
end  
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#