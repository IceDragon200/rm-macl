#-inject gen_class_header 'IO_Relay'
class IO_Relay # < IO
  def relays
    (@relays||=[])
  end
  private relays
  def add_relay io 
    raise 'Relay Loop detected!' if io == self
    relays << io 
  end
  def write *args,&block
    #super *args,&block
    relays.invoke :write,*args,&block 
  end
  def close
    relays.each &:close
  end
  def method_missing sym,*args,&block
    relays.invoke sym,*args,&block
  end
end