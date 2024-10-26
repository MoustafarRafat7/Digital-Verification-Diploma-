vlib work
vlog FSM_010.v FSM_Package.sv FSM_010_tb.sv  +cover -covercells
vsim -voptargs=+acc work.FSM_010_tb -cover
add wave *
coverage save FSM_010_tb.ucdb -onexit -du FSM_010
run -all
