# // 05/15/2012
# // 05/15/2012
# // Created By : IceDragon
module MACL ; end
#require_relative '../StandardLibEx/Hash_Ex'
#require_relative 'Parsers'
module Registry
  class RegError_NoRegistry < Exception
    def message
      "No registry loaded"
    end
  end
  class Leaf
    attr_accessor :is_array,:data_type,:value
    def initialize(is_array,data_type,value)
      @is_array, @data_type, @value = is_array,data_type,value
      @value, = @value unless @is_array
    end
    def to_dtstr
      str = String.new
      str += "a-" if @is_array
      str += @data_type
      str += ":%s" % Array(@value).dup.join(?,)
      str
    end
  end
  # // Converters
  def self.branch2str name,branch
    str = ""
    str += "[:%s]\n" % name
    branch.each_pair.to_a.sort_by{|a|a[0]}.each do |(lkey,leaf)|
      puts [lkey,leaf].inspect
      str += "%s=%s\n" % [lkey,leaf.to_dtstr]
    end
    str += "[/:%s]" % name
    str
  end
  # // Init
  def self.init
    @registry = nil
  end
  # // Checks
  def self.registry?
    return !!@registry
  end
  def self.registry_with_err
    raise RegError_NoRegistry.new unless registry?
    true
  end
  # // Save/Load
  def self.save(filename)
    registry_with_err
    File.open(filename,"w+") do |f|
      @registry.each_pair.to_a.sort_by{|a|a[0]}.each do |(key,value)|
        f.puts branch2str(key,value)
      end
    end
    self
  end
  def self.load(filename)
    @registry = {}
    str = File.read(filename)
    str.scan(/\[[^\/]?:(.+)\]/i).each do |tg|
      tg, = tg
      @registry[tg] ||= {}
      str.scan(/\[:#{tg}\](.*)\[\/:#{tg}\]/m).each do |content|
        content, = content
        content.split(/[\r\n]+/).each do |line|
          mtch = line.match(/(.+)\=(.+)/i)
          if mtch
            a,dt,v = MACL::Parser.parse_dtstr(mtch[2],:all)
            p a,dt,v
            @registry[tg][mtch[1]] = Leaf.new(a,dt,v)
          end
        end
      end
    end
    #puts @registry
    self
  end
  # // Modify
  def self.[](branch,key)
    registry_with_err
    return nil unless @registry.has_key?(branch)
    @registry[branch][key] # // Leaf
  end
  def self.[]=(branch,key,value)
    registry_with_err
    @registry[branch] ||= {}
    @registry[branch][key] = value.is_a?(Leaf) ? value : Leaf.new(*value)
    @registry
  end
  class << self
    alias read :[]
    alias write :[]=
  end
end
Registry.init