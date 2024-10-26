package alsu_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_env_pkg::*;
import alsu_config_obj_pkg::*;
import ALSU_sequence_item_pkg::*;
import ALSU_sequencer_pkg::*;
import ALSU_sequence_pkg::*;

class alsu_test extends uvm_test;

// registering class to factory //
`uvm_component_utils(alsu_test)

alsu_env env;
alsu_config_obj alsu_config_obj_test;
ALSU_main_seq main_sequence;
ALSU_reset_seq reset_sequence;


// constructor //
function new(string name = "alsu_test", uvm_component parent = null);
    super.new(name,parent);
endfunction


// build phase //

function void build_phase(uvm_phase phase);

super.build_phase(phase);

alsu_config_obj_test = alsu_config_obj::type_id::create("alsu_config_obj_test");

if(!uvm_config_db #(virtual alsu_if)::get(this,"","alsu_IF",alsu_config_obj_test.alsu_config_vif)) begin
    `uvm_fatal("build_phase","alsu_test Failed to get the virtual interface from config database.");
end

uvm_config_db #(alsu_config_obj)::set(this,"*","cfg",alsu_config_obj_test);

env = alsu_env::type_id::create("env",this);
main_sequence = ALSU_main_seq::type_id::create("main_sequence",this);
reset_sequence = ALSU_reset_seq::type_id::create("reset_sequence",this);

endfunction 

// run phase //

task run_phase(uvm_phase phase);

super.run_phase(phase);
phase.raise_objection(this);

`uvm_info("run_phase","Reset Asserted",UVM_LOW);
reset_sequence.start(env.agent.sqr);
`uvm_info("run_phase","Reset Deasserted",UVM_LOW);

`uvm_info("run_phase"," Main Stimulus Started",UVM_LOW);
main_sequence.start(env.agent.sqr);
`uvm_info("run_phase","Main Stimulus Finished ",UVM_LOW);

phase.drop_objection(this);

endtask


endclass



endpackage