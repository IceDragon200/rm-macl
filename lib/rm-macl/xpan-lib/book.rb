#
# RGSS3-MACL/lib/xpan-lib/book.rb
#   by IceDragon
#   dc 20/04/2013
#   dc 20/04/2013
# vr 0.0.1
#   Hash Helper
module MACL
  class Book

    DEFAULT_ORDER = [:word, :words, :regexp, :exword, :exwords, :exregexp]

    ##
    # typedef Hash<String, Object*> Dictionary
    # ::entries_lookup(Dictionary dict, Hash[<Symbol[:word || :exword],     String>,
    #                                        <Symbol[:words || :exwords],   Array<String>>,
    #                                        <Symbol[:regexp || :exregexp], Regexp>])
    def self.entries_lookup(dict, ops)
      kys  = dict.keys # result
      ((ops[:order] || DEFAULT_ORDER) & ops.keys).each do |k|
        param = ops[k]
        case k
        when :word     # select keys with this word
          kys.select! { |key| key.include?(param) }
        when :exword   # reject keys with this word
          kys.reject! { |key| key.include?(param) }
        when :words    # select keys with any of these words
          kys.select! { |key| param.any? { |word| key.include?(word) } }
        when :exwords  # reject keys with any of these words
          kys.reject! { |key| param.any? { |word| key.include?(word) } }
        when :regexp   # select keys which match this regexp
          kys.select! { |key| key =~ param }
        when :exregexp # reject keys which match this regexp
          kys.reject! { |key| key =~ param }
        end
      end
      return dict.select_key_pair(*kys)
    end

  end
end
