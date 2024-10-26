package alsu_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_driver extends uvm_driver;

`uvm_component_utils(alsu_driver)

virtual alsu_if alsu_driver_vif;

function new(string name = "alsu_driver" , uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual alsu_if)::get(this,"","alsu_IF",alsu_driver_vif)) begin
    `uvm_fatal("build_phase","alsu_driver failed to get virtual interface from config database.");
end
endfunction


task run_phase (uvm_phase phase);

super.run_phase(phase);
alsu_driver_vif.rst=1'b1;
@(negedge alsu_driver_vif.clk);
alsu_driver_vif.rst=1'b0;
forever begin
alsu_driver_vif.A=$random;
alsu_driver_vif.B=$random;
alsu_driver_vif.opcode=$random;
alsu_driver_vif.cin=$random;
alsu_driver_vif.serial_in=$random;
alsu_driver_vif.red_op_A=$random;
alsu_driver_vif.red_op_B=$random;
alsu_driver_vif.bypass_A=$random;
alsu_driver_vif.bypass_B=$random;
alsu_driver_vif.direction=$random;
@(negedge alsu_driver_vif.clk);
end

endtask

endclass


endpackage