interface alsu_if (clk);

input clk;

bit signed [2:0] A, B;
bit rst;
bit [2:0] opcode;
bit cin, serial_in, red_op_A, red_op_B, bypass_A, bypass_B, direction;
bit signed [5:0] out;
bit [15:0] leds;

endinterface