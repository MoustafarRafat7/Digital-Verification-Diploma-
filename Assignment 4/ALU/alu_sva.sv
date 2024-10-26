module alu_sva();

property Addition ;
@(posedge clk ) Opcode==2'b00 |-> (C == (A+B) );
endproperty

property Subtraction ;
@(posedge clk ) Opcode==2'b01 |-> (C == (A-B) );
endproperty

property Inversion_A ;
@(posedge clk ) Opcode==2'b10 |-> (C == (~A) );
endproperty

property Or_B ;
@(posedge clk ) Opcode==2'b11 |-> (C == (|B) );
endproperty

ADD:assert property (Addition);
SUB:assert property (Subtraction);
Inversion:assert property (Inversion_A);
OR:assert property (Or_B);

ADD_cv:cover property (Addition);
SUB_cv:cover property (Subtraction);
Inversion_cv:cover property (Inversion_A);
OR_cv:cover property (Or_B);

endmodule