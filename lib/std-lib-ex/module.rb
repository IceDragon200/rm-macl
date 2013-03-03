#
# RGSS3-MACL/lib/std-lib-ex/module.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.5.1
class Module

  def memoize(*syms)
    syms.each do |sym|
      nm = 'pre_memoize_%s' % sym.to_s
      alias_method nm, sym
      module_eval(%Q(
        def #{sym}(*args, &block)
          @#{'memoized_%s' % sym.to_s} ||= #{nm}(*args, &block)
        end
      ))
    end

    return true
  end unless method_defined?(:memoize)

  def memoize_as(hash)
    hash.each_pair do |sym, n|
      module_eval(%Q(def #{sym}; @#{sym} ||= #{n} end))
    end

    return true
  end unless method_defined?(:memoize_as)

  ##
  # type_check(Object objs[])
  #
  # checks an object's class against self
  module_eval(%q(
  def type_check(*objs)
    objs.each do
      |obj|

      raise(TypeError,
        "expected kind of #{self} but recieved #{obj.class}"
      ) unless obj.kind_of?(self)
    end

    return true
  end))

end
