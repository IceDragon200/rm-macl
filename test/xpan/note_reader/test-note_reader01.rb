require File.join(File.dirname(__FILE__), 'common.rb')

note_reader = MACL::NoteReader.new
note_reader.add_rule('\S+', :int)
note_reader.add_rule('\S+', :string)
note_reader.add_rule('\S+', :bool)
#note_reader.add_rule('(\S+)', :void)

#p note_reader.to_s
#p note_reader.rules.map(&:first)

notes = <<__ENDNOTE__
  <mynote: 2>
  <mynote: "18">
  <somebool: true>
__ENDNOTE__

notes.each_line do |line|
  pp note_reader.match_rules(line)
end
__END__
[{:rule=>{:name=>"(\\S+)", :param_types=>[:int]},
  :raw=>"<mynote: 2>",
  :params=>["mynote", "2"]}]
[{:rule=>{:name=>"(\\S+)", :param_types=>[:string]},
  :raw=>"<mynote: \"18\">",
  :params=>["mynote", "18"]}]
[{:rule=>{:name=>"(\\S+)", :param_types=>[:bool]},
  :raw=>"<somebool: true>",
  :params=>["somebool", "true"]}]