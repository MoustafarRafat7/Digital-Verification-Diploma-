package shift_reg_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_agent_pkg::*;
import shift_reg_coverage_collector_pkg::*;
import shift_reg_scoreboard_pkg::*;
class shift_reg_env extends uvm_env;
`uvm_component_utils(shift_reg_env)

shift_reg_agent agent;
shift_reg_coverage cov;
shift_reg_scoreboard sb;

function new (string name = "shift_reg_env", uvm_component parent = null);

super.new(name,parent);

endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
agent=shift_reg_agent::type_id::create("agent",this);
cov=shift_reg_coverage::type_id::create("cov",this);
sb=shift_reg_scoreboard::type_id::create("sb",this);

endfunction


function void connect_phase( uvm_phase phase);
    super.connect_phase(phase);
    agent.agent_port.connect(sb.sb_exp);
    agent.agent_port.connect(cov.cov_exp);

endfunction


endclass
endpackage