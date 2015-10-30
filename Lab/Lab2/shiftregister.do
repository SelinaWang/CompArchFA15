vlog -reportprogress 300 -work work shiftregister.t.v
vsim -voptargs="+acc" testshiftregister
add wave -position insertpoint  \
sim:/testshiftregister/parallelDataOut \
sim:/testshiftregister/parallelLoad \
sim:/testshiftregister/peripheralClkEdge \
sim:/testshiftregister/clk \
sim:/testshiftregister/serialDataIn \
sim:/testshiftregister/parallelDataIn
run -all
wave zoom full