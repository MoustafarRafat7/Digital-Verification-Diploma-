package shift_reg_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_env_pkg::*;
import shift_reg_config_obj_pkg::*;
import shift_reg_sequence_pkg::*;
class shift_reg_test extends uvm_test;

`uvm_component_utils(shift_reg_test)

shift_reg_env env;
shift_reg_config shift_reg_cfg;
shift_reg_main_sequence main_seq;
shift_reg_reset_sequence reset_seq;


function new (string name = "shift_reg_test", uvm_component parent = null);

super.new(name,parent);

endfunction


function void build_phase (uvm_phase phase);
super.build_phase(phase);


env = shift_reg_env::type_id::create("env",this);
shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg");
main_seq = shift_reg_main_sequence::type_id::create("main_seq");
reset_seq = shift_reg_reset_sequence::type_id::create("reset_seq");

if(!uvm_config_db #(virtual shift_reg_interface)::get(this,"","shift_reg_IF",shift_reg_cfg.shift_reg_vif)) begin
    `uvm_fatal ("build_Phase","Test can't get virtula interface from config database");
end

uvm_config_db #(shift_reg_config)::set(this,"*","cfg",shift_reg_cfg);


endfunction

task run_phase (uvm_phase phase);

super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","Start Reset sequence",UVM_MEDIUM);
reset_seq.start(env.agent.sqr);
`uvm_info("run_phase","End of Reset sequence",UVM_MEDIUM);
`uvm_info("run_phase","Start of main sequence",UVM_MEDIUM);

main_seq.start(env.agent.sqr);
`uvm_info("run_phase","End of main sequence",UVM_MEDIUM);

phase.drop_objection(this);    
endtask

endclass



endpackage