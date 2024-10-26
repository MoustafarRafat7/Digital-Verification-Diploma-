package alsu_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_sequence_item_pkg::*;
class alsu_driver extends uvm_driver #(ALSU_sequence_item);

`uvm_component_utils(alsu_driver)

virtual alsu_if alsu_driver_vif;
ALSU_sequence_item driver_seq_item;

function new(string name = "alsu_driver" , uvm_component parent = null);
    super.new(name,parent);
endfunction


task run_phase (uvm_phase phase);

super.run_phase(phase);

forever begin
    driver_seq_item = ALSU_sequence_item::type_id::create("driver_seq_item");
    seq_item_port.get_next_item(driver_seq_item);
    alsu_driver_vif.A = driver_seq_item.A ;
    alsu_driver_vif.B = driver_seq_item.B ;
    alsu_driver_vif.rst = driver_seq_item.rst;
    alsu_driver_vif.opcode = driver_seq_item.opcode ;
    alsu_driver_vif.cin = driver_seq_item.cin ;
    alsu_driver_vif.serial_in = driver_seq_item.serial_in ;
    alsu_driver_vif.red_op_A = driver_seq_item.red_op_A ;
    alsu_driver_vif.red_op_B = driver_seq_item.red_op_B ;
    alsu_driver_vif.bypass_A = driver_seq_item.bypass_A ;
    alsu_driver_vif.bypass_B = driver_seq_item.bypass_B ;
    alsu_driver_vif.direction = driver_seq_item.direction ;
    @(negedge alsu_driver_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",driver_seq_item.convert2string_stimulus(),UVM_HIGH)
end
endtask

endclass


endpackage