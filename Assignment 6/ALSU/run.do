vlib work
vlog -f src_files.list  +cover -covercells 
vsim -voptargs=+acc work.alsu_top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/alsu_top/alsuif/*
add wave /alsu_top/DUT/ALSU_SVA/bypass_a_c /alsu_top/DUT/ALSU_SVA/bypass_b_c /alsu_top/DUT/ALSU_SVA/mult_c /alsu_top/DUT/ALSU_SVA/add_c /alsu_top/DUT/ALSU_SVA/or_a_c /alsu_top/DUT/ALSU_SVA/or_b_c /alsu_top/DUT/ALSU_SVA/a_or_b_c /alsu_top/DUT/ALSU_SVA/xor_a_c /alsu_top/DUT/ALSU_SVA/xor_b_c /alsu_top/DUT/ALSU_SVA/a_xor_b_c /alsu_top/DUT/ALSU_SVA/shift_right_c /alsu_top/DUT/ALSU_SVA/shift_left_c /alsu_top/DUT/ALSU_SVA/rotate_right_c /alsu_top/DUT/ALSU_SVA/rotate_left_c /alsu_top/DUT/ALSU_SVA/invalid_1_c /alsu_top/DUT/ALSU_SVA/invalid_2_c
coverage save ALSU.ucdb -onexit 
run -all