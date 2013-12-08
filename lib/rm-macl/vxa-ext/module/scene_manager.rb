#
# rm-macl/lib/rm-macl/vxa-ext/module/scene_manager.rb
#   by IceDragon
require 'rm-macl/macl-core'
module SceneManager

  ##
  # ::recall
  #   restart the current Scene
  def self.recall
    goto(@scene.class)
  end

end
MACL.register('macl/vxa/module/scene_manager', '1.1.0')