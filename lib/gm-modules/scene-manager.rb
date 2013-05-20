#
# RGSS3-MACL/lib/gm-modules/scene-manager.rb
#   by IceDragon
#   dc ??/??/2012
#   dm 03/03/2013
# vr 1.1.0
module SceneManager

  ##
  # ::recall
  #   restart the current Scene
  def self.recall
    goto(@scene.class)
  end

end
