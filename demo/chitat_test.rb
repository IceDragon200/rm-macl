# // 06/02/2012
# // 06/03/2012
begin
  # // Copied from IER - Map Merge
  MERGE  = /merge:\s*(\d+(?:\s*,\s*\d+)*)/i
  SWITCH = /switch:\s*(\d+)-(.*)/i
  XY     = /(?:pos|xy):\s*(\d+)\s*,\s*(\d+)/i
  LAYERS = /layers:\s*([1-3](?:\s*,\s*[1-3]){0,2})/i
  # // Dummy RGSS3
  require_relative '_rgss3_prototype.rb'
  # // RGSS3-MACL Build
  require_relative '../rgss3macl.rb'
  # // Chitat Notefolder Parser
  folder = Chitat.new "merge" do |chi|
    chi.set_tag :merge , MERGE
    chi.set_tag :switch, SWITCH
    chi.set_tag :xy    , XY
    chi.set_tag :layers, LAYERS
  end
  # // A test string
  str = %Q(
<merge>
  merge: 1, 3, 5
  switch: 2-ON
</merge>
cheese
x
<merge>
  merge: 2, 4
  switch: 3-OFF
  pos: 24, 32
  layers: 1, 2, 3
</merge>
<merge>
  merge: 1, 3
</merge>
<merge>
  switch: 2, 4
</merge>
)  
  tag_stacks = folder.parse_str4tags(str)
  tag_stacks.each do |stack|
    puts "--TAGS"
    stack.each do |tags|
      puts tags.inspect
    end
    puts "--END"
  end  
  gets
rescue Exception => ex
  p ex
  p ex.backtrace
  gets
end  