#
# rm-macl/lib/rm-macl/core_ext/math.rb
#   by IceDragon
module Math

  def rootn(x, n)
    exp(log(x) / n)
  end unless method_defined? :rootn

end