=begin

  skrip/skrip.rb
  by IceDragon
  dc 22/10/2012
  dm 22/10/2012

=end
module MethodIntercept

  def before_methods_do(*meths, &func)
    meths.each do |meth| intercept_method(meth, func) end
  end

  def before_method_do(meth, &func)
    without = :"#{meth}_without_intc"
    with    = :"#{meth}_with_intc"
    define_method(with) { |*args, &block|
      args = func.call(*args)
      send(without, *args, &block)
    }
    alias_method(without, meth)
    alias_method(meth, with)
    return true
  end

end

class Skrip
  class FileSystem

    extend MethodIntercept

    def initialize
      @data = Hash.new()
    end

    def get_folder(*dirs)
      
    end

    def file?(*dirs)

    end

    def dir?(*dirs)
      
    end

    def add_folder(path)
      path = split_path(path)
      dhash = @data

    end

    before_methods_do(:dir?, :file?, :get_folder, :add_folder) do |path|
      path = path[0, path.length - 1] if path.ends_with?("\\")
      path.split(File::SEPARATOR)
    end

  end

  def initialize
    @file_system = FileSystem.new()
  end

  def add_folder(path)
    path = path[0, path.length - 1] if path.ends_with?("\\")
    dirs = path.split(File::SEPARATOR)
    @file_system

  end

end
