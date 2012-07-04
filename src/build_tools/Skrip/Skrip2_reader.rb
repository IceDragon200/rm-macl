# // 04/17/2012
# // 04/18/2012
# // Change Log
# // 04/18/2012 - Added header reading
# //              Added Errors
require 'zlib' unless(defined? Zlib) rescue nil
$LOADED_SKPCK = {}
module Skrip
  SkripError = Class.new(StandardError)
  class MissingHeader < SkripError
    def message() ; "Cannot load Skrip Pack. Header is missing"   ; end
  end
  class NoLoadOrder < SkripError
    def message() ; "Header does not contain a valid :load_order" ; end
  end
  module Include
    #module_function
    def load_skrip(binding,skrip);eval(Skrip.skrip2str(skrip),binding);end
    def load_skrips(binding,skpack_hsh)
      raise MissingHeader.new() unless(skpack_hsh[:header])
      raise NoLoadOrder.new() unless(skpack_hsh[:header][:load_order].is_a?(Enumerable))
      skpack_hsh[:header][:load_order].each { |s|
        begin
          load_skrip(binding,skpack_hsh[:contents][s])
          puts "#{s} skrip loaded"
        rescue(Exception) => ex
          puts "#{s} skrip failed to load"
        end
      }
    end
    def load_skpck(name)
      $LOADED_SKPCK[name] = load_data("Skpck/#{name}.skpck")
    end
    def get_skpck(name)
      $LOADED_SKPCK[name]
    end
  end
end
class << Skrip
  def skrip2str(str) ; Zlib::Inflate.inflate(str) ; end
  def inflate_skpck(skpck_h)
    hsh_a = skpck_h.collect{|(name,skrip)|[name,skrip2str(skrip)]}
    Hash[hsh_a]
  end
  def clear_skpcks()
    $LOADED_SKPCK.clear()
    self
  end
end
module Kernel
  include Skrip::Include
end
include Skrip::Include