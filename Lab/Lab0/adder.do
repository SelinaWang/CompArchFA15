vlog -reportprogress 300 -work work adder.v
vsim -voptargs="+acc" test4bitFullAdder
add wave -position insertpoint  \
sim:/test4bitFullAdder/a \
sim:/test4bitFullAdder/b \
sim:/test4bitFullAdder/sum \
sim:/test4bitFullAdder/carryout \
sim:/test4bitFullAdder/overflow
run -all
wave zoom full