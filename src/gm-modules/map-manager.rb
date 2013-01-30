#-inject gen_module_header 'MapManager'
module MapManager

  @@maps = {}

  def self.load_map(id)
    get_map(id).deep_clone
  end

  def self.get_map(id)
    unless @@maps.has_key?(id)
      @@maps[id] = load_data("Data/Map%03d.rvdata2" % id)
      @@maps[id].do_note_scan
    end
    @@maps[id]
  end

  def self.clear
    @@maps.clear
  end

end
