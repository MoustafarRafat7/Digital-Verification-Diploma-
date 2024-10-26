import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;
module  shift_reg_top();

bit clk;

always begin
    clk=1'b0;
    #1;
    clk=1'b1;
    #1;
end

shift_reg_interface shift_reg_if (clk);
shift_reg shift_reg_design (clk, shift_reg_if.reset, shift_reg_if.serial_in, shift_reg_if.direction, shift_reg_if.mode, 
                                shift_reg_if.datain, shift_reg_if.dataout);

initial begin
    uvm_config_db #(virtual shift_reg_interface )::set(null,"uvm_test_top","shift_reg_IF",shift_reg_if);
    run_test("shift_reg_test");
end



endmodule