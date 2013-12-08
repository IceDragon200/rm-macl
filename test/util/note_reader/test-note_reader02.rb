require_relative 'common.rb'

note_reader = MACL::NoteReader.new
note_reader.add_rule('m_int',    :int)
note_reader.add_rule('m_float',  :float)
note_reader.add_rule('m_hex',    :hex)
note_reader.add_rule('m_number', :number)
note_reader.add_rule('m_string', :string)
note_reader.add_rule('m_bool',   :bool)
note_reader.add_rule('m_void',   :void)

note = <<__EOF__
; the following should not be read
  1
  1.1
  #FFF2
  0xFFF2
  "string"
  true
  false
  blah dee dah
; everything here is a valid tag
  <m_int: 2>
  <m_float: 2.567>
  <m_hex: #FF11> ; style 1
  <m_hex: 0x0A1B> ; style 2
  <m_number: 3>
  <m_number: 2.77>
  <m_number: #FFAA>
  <m_number: 0xBBCC>
  <m_string: "My String">
  <m_bool: false>
  <m_void: anything goes here, but be wary of open-ended void tags>
; and now things that are invalid
  <m_int: 2.0> ; using a float in a int tag
  <m_float: "22.4"> ; string for a float
  <m_hex: FF11> ; style 1
  <m_number: "string">
  <m_string: 112>
  <m_bool: no>
__EOF__

pp note_reader.match_rules(note)