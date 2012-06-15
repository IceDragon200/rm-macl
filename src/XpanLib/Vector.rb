#-// Vector
#-// By FenixFyreX
#-// 05/12/2012
#-inject gen_scr_imported_ww 'MACL::Vector', '0x10000'
class Rect
  def in_rect?(rect)
    return false if x < rect.x
    return false if y < rect.y
    return false if width > rect.width
    return false if height > rect.height
    return true
  end
  def to_a
    [x,y,width,height]
  end
  def to_s
    "<Rect: #{to_a}>"
  end
end
class Vector
  def initialize(a=[])
    @points = Array.new(a.size)
    @points.each_index do |i|
      @points[i] = Point.new(a[i])
    end
    @points.uniq!
  end
  def <<(*a,&bl)
    @points << Point.new(*a)
    self
  end
  alias add_point <<
  def >>(*a,&bl)
    if a[0].is_a?(Array); @points.collect! {|p| p unless p == a[0] }.compact!
    elsif a[0].is_a?(Point); @points.collect! {|p| p unless p == a[0] }.compact!
    end
    sort_points
    self
  end
  alias remove_point >>
  def sort_points
    @points.sort! {|p,p2| p.y <=> p2.y && p.x <=> p2.x }
    @points.uniq!
    @points.compact!
    points
  end
  def points
    @points
  end
  def iterate_all_rects(&bl)
    return nil unless block_given?
    sort_points
    rects = sort_points_to_rects
    rects.each do |r| yield r end
    rects
  end
  def all_rects
    sort_points_to_rects
  end
  def sort_points_to_rects
    sort_points
    # convert all points to rects by comparing with other points
    a = @points.each.inject([]) {|ar,p| @points.each {|p2| ar << p.to_rect(p2) }; ar}.compact
    # reject any rects that are within others or have negative width / height
    a = a.reject {|r1| !find_rects_within(r1,a) }.reject {|r1| r1.width < 0 || r1.height < 0 }
    # sort all rects by y, then x, remove duplicates, and return the array
    a.sort {|r,r2| r.y <=> r2.y && r.x <=> r2.x }.uniq
  end
  def find_rects_within(r1,a)
    a.find_all {|r2| r1 != r2 && r1.in_rect?(r2)}.size.zero?
  end
end
class Bitmap
  def fill_vector(vector,color=Color.new)
    vector.iterate_all_rects do |rect|
      fill_rect(rect,color)
    end
  end
end