package ALSU_coverage_collector_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_sequence_item_pkg::*;
class ALSU_coverage extends uvm_component;
`uvm_component_utils(ALSU_coverage)
uvm_analysis_export #(ALSU_sequence_item) cov_export;
uvm_tlm_analysis_fifo #(ALSU_sequence_item) cov_fifo;

ALSU_sequence_item cov_seq_item;

covergroup cvr_gp ;
A_cp:coverpoint cov_seq_item.A {
                    bins A_data_0 ={ZERO};
                    bins A_data_max= {MAXPOS};
                    bins A_data_min= {MAXNEG};
                    bins A_data_default =default;
}
A_cp1:coverpoint cov_seq_item.A  iff (cov_seq_item.red_op_A) {bins A_data_walkingones []={3'b001,3'b010,3'b100};}

B_cp:coverpoint cov_seq_item.B{
                    bins B_data_0 ={ZERO};
                    bins B_data_max= {MAXPOS};
                    bins B_data_min= {MAXNEG};
                    bins B_data_default =default;
}
B_cp1:coverpoint cov_seq_item.B  iff (!cov_seq_item.red_op_A && cov_seq_item.red_op_B) {bins B_data_walkingones []={3'b001,3'b010,3'b100};}

ALU_cp:coverpoint cov_seq_item.opcode {
                         bins Bins_shift[] = {SHIFT,ROTATE};
                         bins Bins_arith[] = {ADD,MULT};
                         bins Bins_bitwise[] = {OR,XOR};
                         illegal_bins Bins_invalid[]={INVALID_6,INVALID_7};
                         bins Bins_trans=(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
}

Cin_cp:coverpoint cov_seq_item.cin {bins cin_zero_one = {0,1};} 
Shift_in_cp:coverpoint cov_seq_item.serial_in {bins SERIAL_IN_zero_one = {0,1};} 
Direction_cp:coverpoint cov_seq_item.direction {bins Direction_zero_one = {0,1};}
RED_OP_A_cp:coverpoint cov_seq_item.red_op_A {bins reduction_a_0={0};
                                 bins reduction_a_1={1};
}
RED_OP_B_cp:coverpoint cov_seq_item.red_op_B {bins reduction_b_0={0};
                                 bins reduction_b_1={1};
}

ADD_MULT_A_B_Zero_MaxP_N:cross  ALU_cp,A_cp,B_cp {
                                bins mult_add_a_b= binsof(ALU_cp.Bins_arith);
                                option.cross_auto_bin_max=0;
}
ADD_CIN: cross Cin_cp,ALU_cp {
                bins Cin_Add_zero_one = binsof(ALU_cp) intersect {ADD} && binsof(Cin_cp.cin_zero_one);
                option.cross_auto_bin_max=0;
}

Shift_Serial_in :cross Shift_in_cp,ALU_cp {
                bins Shift_in_zero_one = binsof(ALU_cp) intersect {SHIFT} && binsof(Shift_in_cp.SERIAL_IN_zero_one);
                option.cross_auto_bin_max=0;
}

ROT_SHIFT_Direction :cross Direction_cp,ALU_cp {
                bins Direction_ROT_Shift_zero_one = binsof(ALU_cp.Bins_shift) && binsof(Direction_cp.Direction_zero_one);
                option.cross_auto_bin_max=0;
}

cross_5: cross  ALU_cp,A_cp1,B_cp {
                bins A_data_walkingones_b_zero = binsof(ALU_cp.Bins_bitwise) && binsof(A_cp1.A_data_walkingones) && binsof(B_cp.B_data_0) ;
                option.cross_auto_bin_max=0;
}
cross_6: cross  ALU_cp,B_cp1,A_cp {
                bins B_data_walkingones_A_zero = binsof(ALU_cp.Bins_bitwise) && binsof(B_cp1.B_data_walkingones) && binsof(A_cp.A_data_0) ;
                option.cross_auto_bin_max=0;
}

Invalid_OR_XOR: cross ALU_cp,RED_OP_A_cp,RED_OP_B_cp {
                      bins invalid_reduction_A = ( binsof(ALU_cp.Bins_shift) || binsof(ALU_cp.Bins_arith) ) && binsof(RED_OP_A_cp.reduction_a_1);
                      bins invalid_reduction_B = ( binsof(ALU_cp.Bins_shift) || binsof(ALU_cp.Bins_arith) ) && binsof(RED_OP_B_cp.reduction_b_1);
                      option.cross_auto_bin_max=0;
}
endgroup

function new (string name = "ALSU_coverage", uvm_component parent = null);
    super.new(name,parent);
   cvr_gp =new() ;
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
    
endfunction

function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);

super.run_phase(phase);
forever begin
cov_fifo.get(cov_seq_item);
cvr_gp.sample();
end
endtask

endclass


endpackage