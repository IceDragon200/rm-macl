#
# src/gm-modules/scene-manager.rb
#
# vr 1.1
module SceneManager

  ##
  # recall
  #
  # restart the current Scene
  def self.recall
    goto(@scene.class)
  end

end
