require File.join(File.dirname(__FILE__), '..', 'common.rb')
p MACL::Formatter.metric_str_to_num("10k")
p MACL::Formatter.metric_str_to_num("1.21362579213k") # -> 1213.62579213
p d = MACL::Formatter.num_to_metric_str(23, 'd')
p MACL::Formatter.metric_str_to_num(d)
p d = MACL::Formatter.num_to_metric_str(2869000)
p MACL::Formatter.metric_str_to_num(d)
__END__
                        Metric prefixes
Prefix  Symbol   1000m    10n             Decimal         English word[n 1] Since[n 2]
yotta     Y     1000^8    10^24  1000000000000000000000000  septillion         1991
zetta     Z     1000^7    10^21     1000000000000000000000  sextillion         1991
exa       E     1000^6    10^18        1000000000000000000  quintillion        1975
peta      P     1000^5    10^15           1000000000000000  quadrillion        1975
tera      T     1000^4    10^12              1000000000000  trillion           1960
giga      G     1000^3    10^9                  1000000000  billion            1960
mega      M     1000^2    10^6                     1000000  million            1960
kilo      k     1000^1    10^3                        1000  thousand           1795
hecto     h     1000^2/3  10^2                         100  hundred            1795
deca      da    1000^1/3  10^1                          10  ten                1795
                1000^0    10^0                           1  one                –
deci      d     1000−1/3  10−1   0.1                        tenth              1795
centi     c     1000−2/3  10−2   0.01                       hundredth          1795
milli     m     1000−1    10−3   0.001                      thousandth         1795
micro     µ     1000−2    10−6   0.000001                   millionth          1960
nano      n     1000−3    10−9   0.000000001                billionth          1960
pico      p     1000−4    10−12  0.000000000001             trillionth         1960
femto     f     1000−5    10−15  0.000000000000001          quadrillionth      1964
atto      a     1000−6    10−18  0.000000000000000001       quintillionth      1964
zepto     z     1000−7    10−21  0.000000000000000000001    sextillionth       1991
yocto     y     1000−8    10−24  0.000000000000000000000001 septillionth       1991

^ This table uses the short scale.
^ The metric system was introduced in 1795 with six prefixes. The other dates relate to recognition by a resolution of the CGPM.