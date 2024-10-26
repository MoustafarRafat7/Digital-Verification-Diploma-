package shift_reg_sequence_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_sequence_item_pkg::*;
import shared_pkg::*;

class shift_reg_main_sequence extends uvm_sequence #(shift_reg_sequence_item);
`uvm_object_utils(shift_reg_main_sequence)

shift_reg_sequence_item seq_item;

function new(string name = "shift_reg_main_sequence");
    super.new(name);
endfunction

task body;
repeat(10000) begin
    seq_item=shift_reg_sequence_item::type_id::create("seq_item");
    start_item(seq_item);
assert(seq_item.randomize());
finish_item(seq_item);
end

endtask

endclass



endpackage