#-inject gen_class_header 'IO_Relay'
class IO_Relay# < IO
  def add_relay io 
    (@relays||=[]) << io
  end
  def write *args,&block
    #super *args,&block
    (@relays||=[]).invoke :write,*args,&block 
  end
end