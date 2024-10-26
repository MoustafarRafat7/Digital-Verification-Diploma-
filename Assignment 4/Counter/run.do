vlib work
vlog *v  +cover -covercells
vsim -voptargs=+acc work.Counter_Top -cover
add wave *
add wave -position insertpoint sim:/Counter_Top/Counter_Design/counter_if/*
coverage save counter_tb.ucdb -onexit
run -all
