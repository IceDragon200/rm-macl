#-apndmacro _imported_
#-inject gen_scr_imported 'Surface', '0x11000'
#-end:
#-inject gen_module_header 'Mixin::Surface'
require_relative 'surface/msurface.rb'
require_relative 'surface/msurface-exfunc.rb'
require_relative 'surface/surface-error.rb'
require_relative 'surface/surface.rb'
require_relative 'surface/surface_to.rb'
