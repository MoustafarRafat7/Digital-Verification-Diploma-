import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_test_pkg::*;
module alsu_top();

bit clk;

initial begin
    clk=1'b0;
forever begin
    #1;clk=~clk;
end
end
shift_reg_interface shift_reg_if ();

alsu_if alsuif(clk);
ALSU DUT (.A(alsuif.A), .B(alsuif.B), .cin(alsuif.cin), .serial_in(alsuif.serial_in), .red_op_A(alsuif.red_op_A)
        , .red_op_B(alsuif.red_op_B), .opcode(alsuif.opcode), .bypass_A(alsuif.bypass_A), .bypass_B(alsuif.bypass_B)
        , .clk(clk), .rst(alsuif.rst), .direction(alsuif.direction), .leds(alsuif.leds), .out(alsuif.out));

bind ALSU ALSU_Assertions ALSU_SVA (
    .A(alsuif.A), .B(alsuif.B), .cin(alsuif.cin), .serial_in(alsuif.serial_in),
    .red_op_A(alsuif.red_op_A), .red_op_B(alsuif.red_op_B), .opcode(alsuif.opcode),
    .bypass_A(alsuif.bypass_A), .bypass_B(alsuif.bypass_B), .clk(clk), .rst(alsuif.rst),
    .direction(alsuif.direction), .leds(alsuif.leds), .out(alsuif.out)
);

assign shift_reg_if.serial_in= DUT.serial_in_reg;
assign shift_reg_if.mode = DUT.opcode_reg[0];
assign shift_reg_if.direction = DUT.direction_reg;
assign shift_reg_if.datain = alsuif.out;
assign shift_reg_if.dataout = DUT.out_shift_reg;

initial begin

uvm_config_db #(virtual alsu_if)::set(null,"uvm_test_top","alsu_IF",alsuif);
uvm_config_db #(virtual shift_reg_interface)::set(null,"uvm_test_top","shift_reg_if",shift_reg_if);
run_test("alsu_test");            

end

endmodule 