#
# rm-macl/lib/rm-macl/xpan/palette/export.rb
#   by IceDragon
require 'rm-macl/macl-core'
require "rm-macl/rgss3-ext/color"

module MACL
  class Palette

    def to_h
      @colors.map { |k,v| [k.to_s, v] }
    end

    def to_gpl
      result = ""
      to_h.each do |key, color|
        result << ("%03s %03s %03s %s\n" % [*color.opaque.to_rgb24_a, key])
      end
      result
    end

    def to_basic_h
      Hash[@colors.map { |k,v| [k.to_s, v.to_a] }]
    end

    def to_basic_normalized_h
      Hash[@colors.map { |k,v| [k.to_s, v.to_a.map { |n| n.to_f/255.0 }] }]
    end

    def to_yaml
      require "yaml"
      to_basic_h.to_yaml
    end

    def to_normalized_yaml
      require "yaml"
      to_basic_normalized_h.to_yaml
    end

    def to_json
      require "json"
      to_basic_h.to_json
    end

    def to_normalized_json
      require "json"
      to_basic_normalized_h.to_json
    end

    def save_file_gpl(filename)
      File.open filename, "w" do |f|
        f.write to_gpl
      end
    end

    def save_file_yaml(filename)
      File.open filename, "w" do |f|
        f.write to_yaml
      end
    end

    def save_file_json(filename)
      File.open filename, "w" do |f|
        f.write to_json
      end
    end

    def save_file_normalized_yaml(filename)
      File.open filename, "w" do |f|
        f.write to_normalized_yaml
      end
    end

    def save_file_normalized_json(filename)
      File.open filename, "w" do |f|
        f.write to_normalized_json
      end
    end

  end
end

MACL.register('macl/xpan/palette/export', '1.0.0')