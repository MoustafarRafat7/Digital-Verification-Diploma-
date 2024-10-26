import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_test_pkg::*;
module alsu_top();

bit clk;

initial begin
    clk=1'b0;
forever begin
    #2;clk=~clk;
end
end
alsu_if alsuif(clk);
ALSU DUT (.A(alsuif.A), .B(alsuif.B), .cin(alsuif.cin), .serial_in(alsuif.serial_in), .red_op_A(alsuif.red_op_A)
        , .red_op_B(alsuif.red_op_B), .opcode(alsuif.opcode), .bypass_A(alsuif.bypass_A), .bypass_B(alsuif.bypass_B)
        , .clk(clk), .rst(alsuif.rst), .direction(alsuif.direction), .leds(alsuif.leds), .out(alsuif.out));
initial begin

uvm_config_db #(virtual alsu_if)::set(null,"uvm_test_top","alsu_IF",alsuif);
run_test("alsu_test");            

end

endmodule 