package alsu_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_env_pkg::*;

class alsu_test extends uvm_test;

// registering class to factory //
`uvm_component_utils(alsu_test)

alsu_env env;

// constructor //
function new(string name = "alsu_test", uvm_component parent = null);
    super.new(name,parent);
endfunction


// build phase //

function void build_phase(uvm_phase phase);

super.build_phase(phase);
env = alsu_env::type_id::create("env",this);

endfunction 

// run phase //

task run_phase(uvm_phase phase);

super.run_phase(phase);
phase.raise_objection(this);

#50;
`uvm_info("run_phase","Inside the ALSU test",UVM_MEDIUM);

phase.drop_objection(this);

endtask


endclass



endpackage