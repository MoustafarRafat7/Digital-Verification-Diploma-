vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.alsu_top -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/alsu_top/alsuif/*
run -all