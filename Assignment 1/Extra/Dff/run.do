vlib work
vlog dff.v dff_t1_tb.sv dff_t2_tb.sv  +cover -covercells
vsim -voptargs=+acc work.dff_t1_tb -cover
add wave *
coverage save dff_t1_tb.ucdb -onexit -du dff
run -all
quit -sim
vsim -voptargs=+acc work.dff_t2_tb -cover
add wave *
coverage save dff_t2_tb.ucdb -onexit -du dff
run -all
quit -sim
vcover merge dff_merged.ucdb dff_t1_tb.ucdb dff_t2_tb.ucdb -du dff
vcover report dff_merged.ucdb -details -annotate -all -output dff_Coverage_Report.txt

