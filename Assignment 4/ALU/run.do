vlib work
vlog ALU.v ALU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
add wave /ALU_tb/SUB_cv /ALU_tb/Inversion_cv /ALU_tb/OR_cv /ALU_tb/ADD_cv
coverage save ALU_tb.ucdb -onexit 
run -all