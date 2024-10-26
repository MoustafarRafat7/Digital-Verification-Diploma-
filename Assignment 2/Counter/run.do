vlib work
vlog counter.v counter_tb.sv Counter_Package.sv  +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter_tb.ucdb -onexit -du counter
run -all
