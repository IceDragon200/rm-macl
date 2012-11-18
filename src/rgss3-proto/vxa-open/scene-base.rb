class Scene_Base

  def main
    start
    post_start
    update until scene_changing?
    pre_terminate
    terminate
  end

  def initialize
  end

  def start
  end

  def post_start
  end

  def update_basic
  end

  def update
  end

  def pre_terminate
  end

  def terminate
  end

  def scene_changing?
    SceneManager.scene != self
  end

end
