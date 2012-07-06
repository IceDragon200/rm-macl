[
  'RPG_Metric.rb',
  'Graphics_Ex.rb',
  'Audio_Ex.rb',
  #'Input_Ex.rb',
  'Color_Ex.rb',
  'Tone_Ex.rb',
  'Font_Ex.rb',
  'Rect_Ex.rb',
  'Table_Ex.rb',
  'Bitmap_Ex.rb',
  'Sprite-Ex.rb',
  #'Window-Ex.rb',
  'RPG_Event_Page_Ex.rb',
  'SceneManager_Ex.rb',
  'MapManager.rb',
  'Game-Map_Ex.rb',
  'Game-Switches_Ex.rb',
  #'Game-Variables_Ex.rb',
].each do |s|
  require_relative s
end