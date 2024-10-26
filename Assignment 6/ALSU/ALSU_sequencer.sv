package ALSU_sequencer_pkg;
import uvm_pkg::*;
`include"uvm_macros.svh"
import ALSU_sequence_item_pkg::*;

class ALSU_sequencer extends uvm_sequencer #(ALSU_sequence_item);
`uvm_component_utils(ALSU_sequencer);

function new (string name = "ALSU_sequencer" , uvm_component parent = null);
    super.new(name,parent);
endfunction



endclass


endpackage