require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
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
  class Circuit
    include Ohms_Law
    class Load
      include Ohms_Law
      class Resistor
        include Ohms_Law
        attr_accessor :name
        attr_accessor :value
        def initialize value,name
          @name = name
          @value
        end
        def + n
          to_f + n.to_f
        end
        def - n
          to_f - n.to_f
        end
        def to_i
          @value
        end
        def to_f
          @value.to_f
        end
        def to_s
          "<#{@name} = #{@value}>"
        end
      end
      class Capacitor
      end
      attr_accessor :elements
      def add_resistor name,value
        @elements.push(Resistor.new value,name)
      end
      def initialize
        @elements = []
      end
      def series?
        @elements.size < 2
      end
      def parrallel?
        @elements.size > 1
      end
      def resistance
        rstrs2ohms @elements
      end
      def add_resistance n
        resistance + n
      end
    end
    attr_accessor :loads
    def initialize
      @loads = [Load.new]
    end
    def add_load
      load = Load.new
      @loads << load
      load
    end
    def rt
      @loads.inject &:add_resistance
    end
    def it
    end
    def vt
    end
    def pt
      calc_power vt,it
    end
  end
  #include Ohms_Law
  #circ = Circuit.new
  #circ.loads.clear
  #load = circ.add_load
  #load.add_resistor "R1", 3.0

  #load = circ.add_load
  #load.add_resistor "R2", 8.0
  #load.add_resistor "R5", 6.0

  #load = circ.add_load
  #load.add_resistor "R3", 4.0
  #load = circ.add_load
  #load.add_resistor "R4", 2.0

  #rt = nil
  #vt = 24.0
  #it = nil
  #pt = nil
  #r1,r2,r3,r4,r5 = 3.0,8.0,4.0,2.0,6.0
  #puts 'Voltage: %s' % vt
  #rt = rstrs2ohms [r1,[[r2,r5],r3,r4]]
  #puts 'Resistance: %s' % rt
  #it = calc_current vt,rt
  #puts 'Current: %s' % it

  #loop do
  #  begin
  #    puts "eval gets"
  #  rescue Exception => ex
  #    p ex
  #  end
  #end
end