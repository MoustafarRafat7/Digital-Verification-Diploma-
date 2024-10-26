vlib work
vlog ALU.v ALU_Package.sv ALU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit -du  ALU_4_bit
run -all

