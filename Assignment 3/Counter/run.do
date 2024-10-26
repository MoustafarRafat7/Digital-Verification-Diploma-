vlib work
vlog Counter_Package.sv counter.v counter_tb.sv  +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter_tb.ucdb -onexit 
run -all
