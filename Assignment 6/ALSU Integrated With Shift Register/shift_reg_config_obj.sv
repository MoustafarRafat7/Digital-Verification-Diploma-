package shift_reg_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_config extends uvm_object;

`uvm_object_utils(shift_reg_config)

virtual shift_reg_interface shift_reg_vif;

uvm_active_passive_enum is_active;

function new(string name = "shift_reg_config");
    super.new(name);
    
endfunction

endclass


endpackage