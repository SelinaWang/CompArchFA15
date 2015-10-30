<<<<<<< HEAD
vlog -reportprogress 300 -work work inputconditioner.t.v
vsim -voptargs="+acc" testConditioner
add wave -position insertpoint  \
sim:/testConditioner/pin \
sim:/testConditioner/conditioned \
sim:/testConditioner/rising \
sim:/testConditioner/falling \
sim:/testConditioner/clk
=======
vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work inputconditioner.t.v
vsim -voptargs="+acc" testConditioner
add wave -position insertpoint  \
sim:/testConditioner/clk \
sim:/testConditioner/pin \
sim:/testConditioner/conditioned \
sim:/testConditioner/rising\
sim:/testConditioner/falling \
sim:/testConditioner/dutpassed
>>>>>>> origin/master
run -all
wave zoom full