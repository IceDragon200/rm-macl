#
# rm-macl/lib/rm-macl/xpan/edst.rb
#   by IceDragon
# EDST is a parser for the .edst file format
# EDST is a custom markup format by IceDragon
# Currently this module is Buggy!
require 'rm-macl/macl-core'
require 'rltk'
require 'rltk/ast'
require 'rltk/parser'
module MACL #:nodoc:
  module EDST
    class Lexer < RLTK::Lexer

      rule(/\s+/)                    #{ :SPACE }

      rule(/@/)                      { :AT }
      rule(/%%/)                     { push_state(:dper); :DPERCENT }
      rule(/\n/, :dper)              { pop_state }
      rule(/[^\n]+/, :dper)          { |t| [:TAG, t] }

      rule(/%/)                      { push_state(:sper); :SPERCENT }
      rule(/[\s\n]/, :sper)              { pop_state }
      rule(/\S+/, :sper)             { |t| [:TAG, t] }

      #rule(/:/)                      { :COLON }
      #rule(/\./)                     { :PERIOD }
      #rule(/,/)                      { :COMMA }
      rule(/"/)                      { push_state(:dquote) }
      rule(/'/)                      { push_state(:squote) }
      rule(/"/, :dquote)             { pop_state }
      rule(/'/, :squote)             { pop_state }
      rule(/[^"]+/, :dquote)         { |t| [:STRING, t.gsub("\n", " ").gsub(/\s+/, "\s")] }
      rule(/[^']+/, :squote)         { |t| [:STRING, t.gsub("\n", " ").gsub(/\s+/, "\s")] }
      # braces
      rule(/\{/)#                     { :LCURLY }
      rule(/\}/)#                     { :RCURLY }
      ### comments
      rule(/#/)                      { push_state(:comment) }
      rule(/\n/, :comment)           { pop_state }
      rule(/./, :comment)
      ### identifier
      rule(/\w+|,|./)                { |t| [:WORD, t] }
      ### header
      rule(/[\w_]+(?::[\w_]+)+/)     { |t| [:HEADER, t] }
      rule(/[0-9]+/)                 { |t| [:NUMBER, t] }
      ## new line
      #rule(/[\n\r]{2}/)              { :DNL }
      #rule(/[\n\r]/)                 { :NL }

    end
    module AST
      class Expression < RLTK::ASTNode
      end
      class Header < Expression
        value :string, String
      end
      class Content < Expression
        value :content, [Object]
      end
      class Context < Content
      end
      class Paragraph < Expression
        value :content, String
      end
      class Dialogue < Expression
        value :speaker, String
        value :text, String
      end
      class Tag < Expression
        value :name, String
      end
    end
    class Parser < RLTK::Parser
      production(:main, "content") { |s| s }
      production(:header, "HEADER", 1) { |s| AST::Header.new(s) }
      production(:tag) do
        clause("SPERCENT TAG") { |_,s| AST::Tag.new(s) }
        clause("DPERCENT TAG") { |_,s| AST::Tag.new(s) }
      end
      #production(:in_braces) do
      #  clause("LCURLY RCURLY") { |_,_| }
      #  clause("LCURLY contents RCURLY") { |_,s,_| AST::Context.new(s) }
      #end
      production(:dialogue, "AT words STRING")        { |_,n,s| AST::Dialogue.new(n, s) }
      production(:paragraph, "words")                 { |s|     AST::Paragraph.new(s) }
      production(:words) do
        clause("WORD")       { |s| s }
        clause("WORD words") { |s,s2| s + " " + s2 }
      end
      production(:contents) do
        clause("content") { |c| Array(c) }
        clause("content contents") { |c,c2| Array(c).concat(c2) }
      end
      production(:content) do
        #clause("in_braces") { |b| b }
        clause("header")    { |h| h }
        clause("tag")       { |t| t }
        clause("dialogue")  { |d| d }
        clause("paragraph") { |p| p }
      end
      #production(:value) do
      #  clause("WORD")      { |s| s }
      #  clause("in_braces") { |s| s }
      #end
      left :main, :content, :header, :tag, :in_braces, :dialogue, :paragraph, :words, :value
      left :content, :header, :tag, :in_braces, :dialogue, :paragraph, :words, :value
      left :header, :tag, :in_braces, :dialogue, :paragraph, :words, :value
      left :words, :value
      finalize lookahead: true, precedence: false, explain: false
    end
  end
end
MACL.register('macl/xpan/edst', "1.0.0")