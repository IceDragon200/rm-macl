require File.join(File.dirname(__FILE__), 'common.rb')

note_reader = MACL::NoteReader.new
note_reader.add_rule('\S+', :int)
note_reader.add_rule('\S+', :string)
note_reader.add_rule('\S+', :bool)
#note_reader.add_rule('\S+', :void)

p note_reader.to_s
p note_reader.rules.map(&:first)

notes = <<__ENDNOTE__
<mynote: 2>
<mynote: "18">
<somebool: true>
__ENDNOTE__

notes.each_line do |line|
  p note_reader.match_rules(line)
end
