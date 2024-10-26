package alsu_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_agent_pkg::*;
import ALSU_coverage_collector_pkg::*;
class  alsu_env extends uvm_env;

// registering class to factory //
`uvm_component_utils(alsu_env)
ALSU_coverage cov;
ALSU_agent agent;
// constructor //
function new(string name = "alsu_env", uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);

super.build_phase(phase);
cov = ALSU_coverage::type_id::create("cov",this);
agent = ALSU_agent::type_id::create("agent",this);

endfunction

function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
agent.agent_ap.connect(cov.cov_export);
endfunction

endclass


endpackage