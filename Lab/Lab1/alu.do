vlog -reportprogress 300 -work work alu.v

vsim -voptargs="+acc" testALU

run 1000000000