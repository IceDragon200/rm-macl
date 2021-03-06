#
# rm-macl/lib/rm-macl/rgss-core-ex/font.rb
#   by IceDragon
require 'rm-macl/macl-core'
class Font

  ##
  # to_h -> Hash
  def to_h
    meths = (self.class.methods).select do |str|
      str.start_with?('default_')
    end
    Hash[meths.map { |s| nm = s.gsub(/\Adefault_/, '');[nm, self.send(nm)] }]
  end unless method_defined?(:to_h)

  ##
  # RGSS2/3 Are unable to Marshal Font objects under normal circumstances.
  # the marshalling works in a pair, if marshal_dump was already defined
  # then if we defined our own marshal_load it may never work, so for
  # best, only if both are not defined.
  if !method_defined?(:marshal_dump) && !method_defined?(:marshal_load)
    def marshal_dump
      return to_h
    end

    def marshal_load(hsh)
      return hsh.each_pair { |key, value| send(key.to_s + ?=, value) }
    end
  end

end
MACL.register('macl/rgss3-ext/font', '1.3.0')