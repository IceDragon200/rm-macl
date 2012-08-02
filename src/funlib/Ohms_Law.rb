#-inject gen_module_header 'Ohms_Law'
module Ohms_Law
  def calc_power volts,amps
    volts * amps
  end
  def calc_current volts,ohms
    volts / ohms
  end
  def calc_voltage amps,ohms
    amps * ohms
  end
  alias calc_vd calc_voltage
  def calc_resistance voltage,amps
    voltage / amps
  end
  def rstrs2ohms resistors
    nr = 0.0
    resistors.each do |r|
      nr += r.is_a?(Array) ? calc_para(r) : calc_series(Array(r))
    end
    nr
  end
  def calc_series resistors
    resistors.inject &:+
  end
  def calc_para resistors
    pars = resistors.collect do |r|
      Rational 1.0,calc_series(Array(r))
    end
    added = pars.inject :+
    Rational(added.denominator,added.numerator).to_f
  end
end