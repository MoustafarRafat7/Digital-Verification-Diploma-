vlib work
vlog Memory_Package.sv Memory.sv Memory_tb.sv +cover -covercells
vsim -voptargs=+acc work.Memory_tb -cover
add wave *
coverage save Memory_tb.ucdb -onexit -du  my_mem 
run -all