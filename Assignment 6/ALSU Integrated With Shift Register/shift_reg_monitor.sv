package shift_reg_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_sequence_item_pkg::*;
import shift_reg_config_obj_pkg::*;
import shared_pkg::*;
class shift_reg_monitor extends uvm_monitor;
`uvm_component_utils(shift_reg_monitor)

virtual shift_reg_interface shift_reg_vif;
shift_reg_sequence_item seq_item;
uvm_analysis_port #(shift_reg_sequence_item) mon_port;

function new (string name = "shift_reg_monitor", uvm_component parent = null);

super.new(name,parent);

endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_port=new("mon_port",this);
    
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        seq_item= shift_reg_sequence_item::type_id::create("seq_item");
      #2;    
    seq_item.direction=direction_e'(shift_reg_vif.direction);
    seq_item.mode=mode_e'(shift_reg_vif.mode);
    seq_item.datain=shift_reg_vif.datain;
    seq_item.serial_in=shift_reg_vif.serial_in; 
    seq_item.reset=shift_reg_vif.reset;
    mon_port.write(seq_item);
`uvm_info("run_phase",seq_item.convert2string_stimulus,UVM_HIGH);

    end

endtask





endclass





endpackage