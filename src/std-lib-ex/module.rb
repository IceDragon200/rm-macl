#-inject gen_class_header 'Module'
class Module

  def memoize *syms
    syms.each do |sym|
      nm = 'pre_memoize_%s' % sym.to_s
      alias_method nm, sym
      module_eval %Q(
        def #{sym}(*args, &block); @#{'memoized_%s' % sym.to_s} ||= #{nm}(*args, &block) end
      )
    end
    true
  end unless method_defined? :memoize

  def memoize_as hash
    hash.each_pair do |sym, n|
      module_eval %Q(def #{sym}; @#{sym} ||= #{n} end)
    end
    true
  end unless method_defined? :memoize_as
  
end
