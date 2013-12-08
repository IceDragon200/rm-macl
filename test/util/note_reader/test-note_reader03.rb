require_relative 'common.rb'

note_reader = MACL::NoteReader.new
note_reader.add_rule('can_fly', :bool)
note_reader.add_rule('can_swim', :bool)
note_reader.add_rule('invincible', :bool)
note_reader.add_rule('name', :string)
note_reader.add_rule('strings', :string, :string)

note = <<__EOF__
some stuff that doesn't matter
  <can_fly: true> <can_swim: true>
  <invincible: false>
  <name: "ThisIsMyName">
  <strings: "string1", "string2">
  other stuff
  <some_other_tag: true>
__EOF__

pp note_reader.match_rules(note)