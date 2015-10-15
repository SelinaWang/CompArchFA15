vlog -reportprogress 300 -work work alu.v
vsim -voptargs="+acc" testALU
add wave -position insertpoint \
sim:/testALU/operandA \
sim:/testALU/operandB \
sim:/testALU/command \
sim:/testALU/result \
sim:/testALU/carryout \
sim:/testALU/zero \
sim:/testALU/overflow
run -all
wave zoom full