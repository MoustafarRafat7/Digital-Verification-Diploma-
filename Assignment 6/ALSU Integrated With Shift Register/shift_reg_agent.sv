package shift_reg_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_sequence_item_pkg::*;
import shift_reg_driver_pkg::*;
import shift_reg_monitor_pkg::*;
import shift_reg_agent_pkg::*;
import shift_reg_config_obj_pkg::*;
import shift_reg_sequencer_pkg::*;

class shift_reg_agent extends uvm_agent;
`uvm_component_utils(shift_reg_agent)

shift_reg_driver driver;
shift_reg_monitor monitor;
shift_reg_sequencer  sqr;
shift_reg_config shift_reg_cfg;

uvm_analysis_port #(shift_reg_sequence_item) agent_port;

function new (string name = "shift_reg_agent", uvm_component parent = null);

super.new(name,parent);

endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);

if(! uvm_config_db #(shift_reg_config)::get(this,"","shift_reg_cfg",shift_reg_cfg) ) begin
    `uvm_fatal("build_phase","unable to get the config obj from config database");
end

if(shift_reg_cfg.is_active == UVM_ACTIVE ) begin
driver = shift_reg_driver::type_id::create("driver",this);
sqr = shift_reg_sequencer::type_id::create("sqr",this);    
end
monitor = shift_reg_monitor::type_id::create("monitor",this);
agent_port=new("agent_port",this);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(shift_reg_cfg.is_active == UVM_ACTIVE) begin

driver.seq_item_port.connect(sqr.seq_item_export);
driver.shift_reg_vif=shift_reg_cfg.shift_reg_vif;
end

monitor.mon_port.connect(agent_port);
monitor.shift_reg_vif=shift_reg_cfg.shift_reg_vif;

endfunction




endclass





endpackage