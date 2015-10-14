vlog -reportprogress 300 -work work alu.v
vsim -voptargs="+acc" testALU
add wave -position insertpoint  \
sim:/testALU/a \
sim:/testALU/b \
sim:/testALU/command \
sim:/testALU/zero \
sim:/testALU/carryout \
sim:/testALU/overflow \
sim:/testALU/result 
run -all
wave zoom full