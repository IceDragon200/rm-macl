# ╒╕ ♥                                                              Hashnex ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Hashnex < Hash
  def method_missing sym,*args,&block
  	return self[sym] if has_key? sym
  	super sym,*args,&block
  end
end