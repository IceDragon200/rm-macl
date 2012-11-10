#-inject gen_module_header 'MACL'
module MACL

  @@initialized = []
  @@inits = []

  def self.init
    constants.collect(&method(:const_get)).each(&method(:invoke_init))
    run_init # // Extended scripts
  end

  def self.invoke_init nnodule
    nnodule.init if nnodule.respond_to? :init
  end

  def self.add_init sym, &func
    @@inits << [sym,func]
  end

  def self.run_init
    @@inits.each do |(sym,func)|
      p "%s was already initialized" if @@initialized.include? sym
      begin
        func.call 
      rescue Exception => ex
        p 'MACL: %s failed to load:' % sym.to_s
        p ex
        next
      end
      @@initialized << sym
    end
  end

  module Mixin
  end

end
