require File.join(File.dirname(__FILE__), '..', 'common.rb')
require 'rchart'

def plot_graph(points)
  rd = Rdata.new
  points.each do |po|
    p po
    rd.add_point(po.x, "x")
    rd.add_point(po.y, "y")
  end
  #rd.add_all_series

  rd.set_serie_name("x","x")
  rd.set_serie_name("y","y")
  rd.add_serie("x")
  rd.add_serie("y")
  rd.set_x_axis_name("X Axis")
  rd.set_y_axis_name("Y Axis")
  ch = Rchart.new(640, 640)
  ch.draw_graph_area_gradient(0,0,0,-100,Rchart::TARGET_BACKGROUND);
  ch.set_font_properties("tahoma.ttf",8)
  ch.set_graph_area(32, 32, 612, 612)
  ch.draw_xy_scale(rd.get_data,rd.get_data_description,"x","y",213,217,221,true,45)
  ch.draw_graph_area(213, 217, 221,false)
  ch.draw_graph_area_gradient(30,30,30,-50);
  ch.draw_grid(4,true,230,230,230,20)
  ch.set_shadow_properties(2,2,0,0,0,60,4)

  # Draw XY Chart
  ch.draw_xy_graph(rd.get_data,rd.get_data_description,"x","y",0)
  ch.clear_shadow

  title= "Drawing X versus Y charts Rectangle#lerp  ";
  ch.draw_text_box(0,280,300,300,"#{title}",0,255,255,255,Rchart::ALIGN_RIGHT,true,0,0,0,30)
  ch.set_font_properties("pf_arma_five.ttf",6)
  rd.remove_serie("y")
  ch.draw_legend(160,5,rd.get_data_description,0,0,0,0,0,0,255,255,255,false)
  ch.render_png("xy-chart.png")
end