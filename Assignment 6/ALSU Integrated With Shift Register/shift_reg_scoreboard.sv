package shift_reg_scoreboard_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_sequence_item_pkg::*;
import shared_pkg::*;
class shift_reg_scoreboard extends uvm_scoreboard;
`uvm_component_utils(shift_reg_scoreboard)

shift_reg_sequence_item seq_item_sb;
uvm_analysis_export #(shift_reg_sequence_item) sb_exp;
uvm_tlm_analysis_fifo #(shift_reg_sequence_item) sb_fifo;
bit [5:0] dataout_ref;
 
 int error_count=0 ;
 int correct_count=0;
function new (string name = "shift_reg_scoreboard", uvm_component parent = null);

super.new(name,parent);

endfunction

function void build_phase (uvm_phase phase);

super.build_phase(phase);
sb_exp=new("sb_exp",this);
sb_fifo=new("sb_fifo",this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_exp.connect(sb_fifo.analysis_export);
    
endfunction


task run_phase (uvm_phase phase);

super.run_phase(phase);
forever begin
    sb_fifo.get(seq_item_sb);
check_result(seq_item_sb);
if(dataout_ref != seq_item_sb.dataout) begin
    error_count = error_count+1;
    `uvm_error("run_phase",$sformatf("comparison failed , Transaction recieved by DUT is : %s while the reference output =0b%0b",seq_item_sb.convert2string(),dataout_ref));
end
else begin
    correct_count=correct_count+1;
    `uvm_info("run_phase",$sformatf("Correct shift_ref out = %s",seq_item_sb.convert2string()) ,UVM_HIGH);
end
    
end
endtask

task check_result (shift_reg_sequence_item seq_item_chk) ;

if (seq_item_chk.reset)
      dataout_ref = 0;
   else begin
      if (seq_item_chk.mode == ROTATE) // rotate
         if (seq_item_chk.direction == LEFT) // left
            dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.datain[5]};
         else
            dataout_ref = {seq_item_chk.datain[0], seq_item_chk.datain[5:1]};
      else begin // shift
         if (seq_item_chk.direction == LEFT) // left
            dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.serial_in};
         else
            dataout_ref = {seq_item_chk.serial_in, seq_item_chk.datain[5:1]};
      end
   end
endtask

function void report_phase (uvm_phase phase);
   super.report_phase(phase);
   `uvm_info("report_phase",$sformatf("Total Successful transactions = %0d",correct_count),UVM_MEDIUM);
   `uvm_info("report_phase",$sformatf("Total failed transactions = %0d",error_count),UVM_MEDIUM);
    
endfunction




endclass

endpackage