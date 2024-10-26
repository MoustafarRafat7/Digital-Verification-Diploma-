package alsu_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_env_pkg::*;
import alsu_config_obj_pkg::*;

class alsu_test extends uvm_test;

// registering class to factory //
`uvm_component_utils(alsu_test)

alsu_env env;
alsu_config_obj alsu_config_obj_test;
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


endfunction 

// run phase //

task run_phase(uvm_phase phase);

super.run_phase(phase);
phase.raise_objection(this);

#100;
`uvm_info("run_phase","Inside the ALSU test",UVM_MEDIUM);

phase.drop_objection(this);

endtask


endclass



endpackage