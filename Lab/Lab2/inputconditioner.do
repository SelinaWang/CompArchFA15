vlog -reportprogress 300 -work work inputconditioner.t.v
vsim -voptargs="+acc" testConditioner
add wave -position insertpoint  \
sim:/testConditioner/pin \
sim:/testConditioner/conditioned \
sim:/testConditioner/rising \
sim:/testConditioner/falling \
sim:/testConditioner/clk
run -all
wave zoom full