module SkripII
  module Writer
    include Constants
    module_function
    def pack_str str
      Zlib.deflate(str)
    end
    def make_skrip_pack_header load_type=:manual
      {
        type: LOAD_TYPE[load_type],
        load: [],
        files: [],
        build_time: Time.now.to_f,
        build_name: ''
      }
    end
    class << self ; alias mk_header make_skrip_pack_header ; end
    def marshal_skpack file,header,contents
      Marshal.dump(header,file)
      Marshal.dump(contents,file)
    end
    def mk_file filename
      File.open(filename,'wb')
    end
    def mk_skpack filename,header,contents
      file = mk_file(filename)
      marshal_skpack file,header,contents
      file.close
    end
  end
  def self.mk_skp! filenames, skp_name, load_type
    pre_hash = filenames.collect do |fn|
      [fn, SkripII::Writer.pack_str(File.read(fn))]
    end
    filename = skp_name % SkripII::SKPII_FILE_EXT[:pack]
    puts 'Creating Header'
    header   = SkripII::Writer.mk_header load_type
    header[:files] = filenames
    puts "Files Found:\n#{header[:files]}\n"
    yield :header, header if block_given?
    contents = Hash[pre_hash]
    yield :contents, contents if block_given?
    SkripII::Writer.mk_skpack filename, header, contents
  end  
end