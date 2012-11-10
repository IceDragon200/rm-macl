#-inject gen_module_header 'SceneManager'
module SceneManager
  def self.recall
    goto(@scene.class)
  end
end