# Copied straight from the RPG Maker VXA Scripts
module SceneManager
  
  @scene = nil                            
  @stack = []                             
  @background_bitmap = nil                
  
  def self.run
    DataManager.init
    Audio.setup_midi if use_midi?
    @scene = first_scene_class.new
    @scene.main while @scene
  end
  
  def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Title
  end
  
  def self.use_midi?
    $data_system.opt_use_midi
  end
  
  def self.scene
    @scene
  end
  
  def self.scene_is?(scene_class)
    @scene.instance_of?(scene_class)
  end
  
  def self.goto(scene_class)
    @scene = scene_class.new
  end
  
  def self.call(scene_class)
    @stack.push(@scene)
    @scene = scene_class.new
  end
  
  def self.return
    @scene = @stack.pop
  end
  
  def self.clear
    @stack.clear
  end
  
  def self.exit
    @scene = nil
  end
  
  def self.snapshot_for_background
    @background_bitmap.dispose if @background_bitmap
    @background_bitmap = Graphics.snap_to_bitmap
    @background_bitmap.blur
  end
  
  def self.background_bitmap
    @background_bitmap
  end
  
end
