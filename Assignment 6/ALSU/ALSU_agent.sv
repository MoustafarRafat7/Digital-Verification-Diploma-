package ALSU_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_sequencer_pkg::*;
import ALSU_monitor_pkg::*;
import alsu_driver_pkg::*;
import alsu_config_obj_pkg::*;
import ALSU_sequence_item_pkg::*;
class ALSU_agent extends uvm_agent ;
`uvm_component_utils(ALSU_agent)

ALSU_monitor mon;
alsu_driver driver;
ALSU_sequencer sqr;
alsu_config_obj alsu_cfg;
virtual alsu_if alsu_vif;

uvm_analysis_port #(ALSU_sequence_item) agent_ap;

function new(string name = "ALSU_agent", uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
if(! uvm_config_db #(alsu_config_obj)::get(this,"","cfg",alsu_cfg)) begin
    `uvm_fatal("build_phase","Agent unable to get the configuration object from config database");
end

mon = ALSU_monitor::type_id::create("mon",this);
driver = alsu_driver::type_id::create("driver",this);
sqr = ALSU_sequencer::type_id::create("sqr",this);
agent_ap = new("agent_ap",this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.alsu_driver_vif = alsu_cfg.alsu_config_vif;
    mon.alsu_vif= alsu_cfg.alsu_config_vif;
    driver.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agent_ap);
    
    
endfunction

endclass


endpackage