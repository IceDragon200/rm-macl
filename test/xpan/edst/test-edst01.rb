require_relative 'common.rb'
str = File.read("data/sample.edst")
str.each_line do |s|
  begin
    MACL::EDST::Lexer.lex(s)
  rescue => ex
    p s
  end
end
#pp MACL::EDST::Lexer.lex('"text some more text"')
lexs = MACL::EDST::Lexer.lex(str)
lexs.each do |token| #
  pp [token.type, token.value]
end
p lexs.map(&:value)
pp MACL::EDST::Parser.parse(lexs, verbose: true)