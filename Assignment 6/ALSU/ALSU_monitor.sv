package ALSU_monitor_pkg;

import uvm_pkg::*;
`include"uvm_macros.svh"
 import ALSU_sequence_item_pkg::*;

class ALSU_monitor extends uvm_monitor;
`uvm_component_utils(ALSU_monitor)

ALSU_sequence_item mon_seq_item;
virtual alsu_if alsu_vif;
uvm_analysis_port #(ALSU_sequence_item) mon_ap;

function new (string name = "ALSU_monitor" , uvm_component parent = null);
    super.new(name,parent);
endfunction

// build phase //

function void build_phase(uvm_phase phase);

super.build_phase(phase);
mon_ap = new("mon_ap",this);

endfunction 

// run phase // 

task run_phase (uvm_phase phase) ;

super.run_phase(phase);

forever begin
    mon_seq_item = ALSU_sequence_item::type_id::create("mon_seq_item");
    @(negedge alsu_vif.clk)
mon_seq_item.A = alsu_vif.A;
mon_seq_item.B = alsu_vif.B;
mon_seq_item.opcode = opcode_e'(alsu_vif.opcode);
mon_seq_item.cin = alsu_vif.cin;
mon_seq_item.serial_in = alsu_vif.serial_in;
mon_seq_item.red_op_A = alsu_vif.red_op_A;
mon_seq_item.red_op_B = alsu_vif.red_op_B;
mon_seq_item.bypass_A = alsu_vif.bypass_A;
mon_seq_item.bypass_B = alsu_vif.bypass_B;
mon_seq_item.direction = alsu_vif.direction;
mon_ap.write(mon_seq_item);
`uvm_info("run_phase",$sformatf("sequence item broadcast done ,%s",mon_seq_item.convert2string),UVM_HIGH);
end

endtask




endclass

endpackage