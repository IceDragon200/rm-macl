#-//Standard Library Header
────────────────────────────────────────────────────────────────────────────────
Standard Library
────────────────────────────────────────────────────────────────────────────────
  ♥ Object
    deep_clone 
      ● Return
          <self>
    if_eql?(obj,alt=nil), if_neql?(obj,alt=nil)
      ● Parameters 
          <Object> obj, alt
      ● Return
          if block_given:
            <Object> from yield
          else:
            alt from Parameters
    if_nil?(alt=nil)
      ● Parameters 
          <Object> alt
      ● Return
          if block_given:
            <Object> from yield
          else:
            alt from Parameters
    to_bool 
      ● Return
          Boolean
  ■ Kernel
    load_data(filename) [None-RGSS2/3]
      ● Parameters 
          String filename
      ● Return
          <Object>
    save_data(obj,filename) [None-RGSS2/3]
      ● Parameters 
          <Object> obj
          String filename
      ● Return
          <Object>
    load_data_cin(filename) { obj }
      ● Parameters 
          String filename
      ● Return
          <Object>
    Boolean(obj)
      ● Parameters 
          Object obj 
      ● Return
          Boolean 
  ♥ Numeric
    min(n), max(n)
      ● Parameters 
          Numeric n
      ● Return
          Numeric
    clamp(min,max)
      ● Parameters 
          Numeric min, max
      ● Return
          Numeric
    pole
      ● Return
          Numeric{0,1}
    pole_inv
      ● Return
          not pole
  ■ Enumerable
    pick
      ● Return
          <Object>
    reverse_index(obj), reverse_index { |obj| Compare }
      ● Parameters 
          <Object> obj
      ● Return
          Integer
    invoke(meth_sym,*args)
      ● Parameters 
          Symbol     meth_sym
          <Object>[] args
      ● Return
          <self>
    invoke_collect(meth_sym,*args)
      ● Parameters 
          Symbol     meth_sym
          <Object>[] args
      ● Return
          <Object>[]
  ♥ Array
    pick!
      ● Return
          <Object>
    pad(n, obj), pad!(n, obj), pad(n) { obj }, pad!(n) { obj }
      ● Parameters 
          <Object> obj
      ● Return
          <self>
    uniq_arrays(groups), uniq_arrays!(groups)
      ● Parameters 
          <Object>[] groups
      ● Return
          Array or <self>
    remove_this(obj,n)
      ● Parameters 
          <Object> obj
          Integer n
      ● Return
          <self>
  ♥ Hash
    get_values(*keys)
      ● Parameters 
          <Object>[] keys
      ● Return
          <Object>[]
    enum2keys,enum2keys!
      ● Return
          Hash or <self> 