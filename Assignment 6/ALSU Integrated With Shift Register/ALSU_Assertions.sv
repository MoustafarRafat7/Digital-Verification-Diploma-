import ALSU_sequence_item_pkg::*;
module ALSU_Assertions(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
input clk, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B; // A,B signed inputs
input signed cin;
input reg [15:0] leds;
input reg signed [5:0] out;  // out signed output.

// Valid Casses // 
property BYPASS_A;
@(posedge clk ) disable iff(rst)  ( bypass_A && INPUT_PRIORITY == "A") |=> ##1 ( (out == ( $past(A,2) )) ) ;  
endproperty

property BYPASS_B;
@(posedge clk ) disable iff(rst) (!bypass_A && bypass_B) |=> ##1 ( (out == ( $past(B,2) ) )) ;  
endproperty

property Full_Adder ;
@(posedge clk) disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B) (opcode == ADD && FULL_ADDER == "ON") |=> ##1 ( (out == ( $past(A,2)+$past(B,2) + $past(cin,2) ) ) && ( leds == 16'b0 ) ) ;  
endproperty

property Multiplication;
@(posedge clk)  disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B)  (opcode == MULT) |=> ##1 ( out == ( $past(A,2)*$past(B,2) ) &&( leds == 16'b0 ) );  
endproperty

property OR_A;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == OR && red_op_A) |=> ##1 ( out == ( |$past(A,2) ) && ( leds == 16'b0 ) ); 
endproperty

property OR_B;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == OR && !red_op_A && red_op_B) |=> ##1 ( out == ( |$past(B,2) ) && ( leds == 16'b0 ) ); 
endproperty

property A_OR_B;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == OR && !red_op_A && !red_op_B) |=> ##1 ( out == ($past(A,2) |$past(B,2) ) && ( leds == 16'b0 ) ); 
endproperty


property XOR_A;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == XOR && red_op_A) |=> ##1 ( out == ( ^$past(A,2) ) && ( leds == 16'b0 ) ); 
endproperty

property XOR_B;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == XOR && !red_op_A && red_op_B) |=> ##1 ( out == ( ^$past(B,2) ) && ( leds == 16'b0 ) ); 
endproperty

property A_XOR_B;
@(posedge clk) disable iff (rst || bypass_A || bypass_B ) (opcode == XOR && !red_op_A && !red_op_B) |=> ##1 ( out == ($past(A,2) ^ $past(B,2) ) && ( leds == 16'b0 ) ); 
endproperty

property SHIFT_LEFT;
@(posedge clk) disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B) (opcode == SHIFT && direction == 1'b1) |=> ##1 ( ( out == {$past(out[4:0]),$past(serial_in,2)} ) && ( leds == 16'b0 ) ); 
endproperty

property SHIFT_RIGHT;
@(posedge clk) disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B) (opcode == SHIFT && direction == 1'b0) |=> ##1 ( ( out == {$past(serial_in,2),$past(out[5:1])} ) && ( leds == 16'b0 ) ); 
endproperty

property ROTATE_LEFT;
@(posedge clk) disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B) (opcode == ROTATE && direction == 1'b1) |=> ##1 ( ( out == {$past(out[4:0]),$past(out[5])} ) && ( leds == 16'b0 ) ); 
endproperty

property ROTATE_RIGHT;
@(posedge clk) disable iff (rst || bypass_A || bypass_B || red_op_A || red_op_B) (opcode == ROTATE && direction == 1'b0) |=> ##1 ( ( out == {$past(out[0]),$past(out[5:1])} ) && ( leds == 16'b0 ) ); 
endproperty

// Invalid Cases //
property INVALID_1;
@(posedge clk ) disable iff(rst || bypass_A || bypass_B) (opcode == INVALID_6 || opcode == INVALID_7) |=> ##1 (out == 6'b0 );
endproperty

property INVALID_2;
@(posedge clk ) disable iff(rst || bypass_A || bypass_B) ( (opcode != OR) && (opcode != XOR) && (red_op_A || red_op_B) ) |=> ##1 (out == 6'b0);
endproperty

property INVALID_1_leds;
@(posedge clk ) disable iff(rst || bypass_A || bypass_B) (opcode == INVALID_6 || opcode == INVALID_7) |=> ##1 (leds == ~$past(leds));
endproperty

property INVALID_2_leds;
@(posedge clk ) disable iff(rst || bypass_A || bypass_B) ( (opcode != OR) && (opcode != XOR) && (red_op_A || red_op_B) ) |=> ##1 (leds == ~$past(leds));
endproperty


bypass_a_a:assert property(BYPASS_A);
bypass_a_c:cover property(BYPASS_A);

bypass_b_a:assert property(BYPASS_B);
bypass_b_c:cover property(BYPASS_B);

mult_a:assert property (Multiplication);
mult_c:cover property (Multiplication);

add_a:assert property (Full_Adder);
add_c:cover property (Full_Adder);

or_a_a:assert property (OR_A);
or_a_c:cover property (OR_A);

or_b_a:assert property (OR_B);
or_b_c:cover property (OR_B);

a_or_b_a:assert property (A_OR_B);
a_or_b_c:cover property (A_OR_B);


xor_a_a:assert property (XOR_A);
xor_a_c:cover property (XOR_A);

xor_b_a:assert property (XOR_B);
xor_b_c:cover property (XOR_B);

a_xor_b_a:assert property (A_XOR_B);
a_xor_b_c:cover property (A_XOR_B);

shift_right_a:assert property (SHIFT_RIGHT);
shift_right_c:cover property (SHIFT_RIGHT);

shift_left_a:assert property (SHIFT_LEFT);
shift_left_c:cover property (SHIFT_LEFT);

rotate_right_a:assert property (ROTATE_RIGHT);
rotate_right_c:cover property (ROTATE_RIGHT);

rotate_left_a:assert property (ROTATE_LEFT);
rotate_left_c:cover property (ROTATE_LEFT);

invalid_1_a:assert property(INVALID_1);
invalid_1_c:cover property(INVALID_1);

invalid_2_a:assert property(INVALID_2);
invalid_2_c:cover property(INVALID_2);

invalid_1_leds_a:assert property(INVALID_1_leds);
invalid_1_leds_c:cover property(INVALID_1_leds);

invalid_2_leds_a:assert property(INVALID_2_leds);
invalid_2_leds_c:cover property(INVALID_2_leds);




always_comb begin : reset_outputs
    if(rst)
    reset_a:assert final (out == 0 && leds ==0 );
end


endmodule