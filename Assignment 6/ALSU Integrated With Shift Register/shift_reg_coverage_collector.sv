package shift_reg_coverage_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_sequence_item_pkg::*;

class shift_reg_coverage extends uvm_component;
`uvm_component_utils(shift_reg_coverage)

shift_reg_sequence_item seq_item_cov;
uvm_analysis_export #(shift_reg_sequence_item) cov_exp;
uvm_tlm_analysis_fifo #(shift_reg_sequence_item) cov_fifo;

covergroup shift_reg_cvg ;

serial_in_cp :      coverpoint seq_item_cov.serial_in;
data_in_cp   :      coverpoint seq_item_cov.datain;
direction_cp :      coverpoint seq_item_cov.direction;
mode_cp      :      coverpoint seq_item_cov.mode;
endgroup

function new (string name = "shift_reg_coverage", uvm_component parent = null);

super.new(name,parent);
shift_reg_cvg=new();
endfunction

function void build_phase (uvm_phase phase);

super.build_phase(phase);
cov_exp=new("cov_exp",this);
cov_fifo=new("cov_fifo",this);


endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_exp.connect(cov_fifo.analysis_export);
    
endfunction

task run_phase(uvm_phase phase);

super.run_phase(phase);
forever begin
    cov_fifo.get(seq_item_cov);
    shift_reg_cvg.sample();
end


endtask



endclass





    endpackage 