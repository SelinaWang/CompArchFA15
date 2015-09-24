vlog -reportprogress 300 -work work adder.v
vsim -voptargs="+acc" testFullAdder
add wave -position insertpoint  \
sim:/testFullAdder/a \
sim:/testFullAdder/b \
sim:/testFullAdder/carryin \
sim:/testFullAdder/sum \
sim:/testFullAdder/carryout
run -all
wave zoom full