module ALU_tb();
//   Signals Declrations     //
logic clk,reset;
logic [1:0]Opcode;
logic signed [3:0] A,B;
logic signed [4:0] C;

//   Local Parameters    //
localparam T = 4;
localparam MAXneg=7;
localparam MAXNEG=-8;
localparam Zero =0 ;

// DUT Instantiation    //
ALU_4_bit alu(
        .clk(clk),
        .reset(reset),
        .Opcode(Opcode),
        .A(A),
        .B(B),
        .C(C)
        );

//   Clock Generation     //
always 
begin
clk=1'b0;
#(T/2);
clk=1'b1;
#(T/2);
end

//	Stimulus Generation		//	
initial
begin

// ALU_reset_1 //
reset=1'b1;
// ALU_Addition_2 //
@(negedge clk);
#1;
reset=1'b0;
Opcode=2'b00;
A=MAXneg;
B=MAXneg;

// ALU_Addition_3 //
@(negedge clk);
#1;
A=MAXNEG;
B=MAXNEG;

// ALU_Addition_4 //
@(negedge clk);
#1;
A=Zero;
B=Zero;

// ALU_Addition_5 //
@(negedge clk);
#1;
A=MAXneg;
B=MAXNEG;

// ALU_Addition_6 //
@(negedge clk);
#1;
A=MAXneg;
B=Zero;

// ALU_Addition_7 //
@(negedge clk);
#1;
A=MAXNEG;
B=MAXneg;

// ALU_Addition_8 //
@(negedge clk);
#1;
A=MAXNEG;
B=Zero;

// ALU_Addition_9 //
@(negedge clk);
#1;
A=Zero;
B=MAXneg;

// ALU_Addition_10 //
@(negedge clk);
#1;
A=Zero;
B=MAXNEG;

// ALU_Subtraction_11 //
@(negedge clk);
#1;
Opcode=2'b01;
A=MAXneg;
B=MAXneg;

// ALU_Subtraction_12 //
@(negedge clk);
#1;
A=MAXNEG;
B=MAXNEG;

// ALU_Subtraction_13 //
@(negedge clk);
#1;
A=Zero;
B=Zero;

// ALU_Subtraction_14 //
@(negedge clk);
#1;
A=MAXneg;
B=MAXNEG;

// ALU_Subtraction_15 //
@(negedge clk);
#1;
A=MAXneg;
B=Zero;

// ALU_Subtraction_16 //
@(negedge clk);
#1;
A=MAXNEG;
B=MAXneg;

// ALU_Subtraction_17 //
@(negedge clk);
#1;
A=MAXNEG;
B=Zero;

// ALU_Subtraction_18 //
@(negedge clk);
#1;
A=Zero;
B=MAXneg;

// ALU_Subtraction_19 //
@(negedge clk);
#1;
A=Zero;
B=MAXNEG;

// ALU_Inversion_20 //
@(negedge clk);
#1;
Opcode=2'b10;
A=Zero;

// ALU_Inversion_21 //
@(negedge clk);
#1;
A=4'b1111;

// ALU_Inversion_22  //
@(negedge clk);
#1;
A=MAXneg;

// ALU_Inversion_23  //
@(negedge clk);
#1;
A=MAXNEG;

// ALU_Rediction_OR_24 //
@(negedge clk);
#1;
Opcode=2'b11;
B=MAXNEG;

// ALU_Rediction_OR_25 //
@(negedge clk);
#1;
B=MAXneg;

// ALU_Rediction_OR_26 //
@(negedge clk);
#1;
B=4'b1100;


// ALU_Rediction_OR_27 //
@(negedge clk);
#1;
B=4'b0001;


// ALU_Rediction_OR_28 //
@(negedge clk);
#1;
B=Zero;


// ALU_Rediction_OR_29 //
@(negedge clk);
#1;
B=4'b1111;

@(negedge clk);
#1;
reset=1'b1;
@(negedge clk);
#1;
reset=1'b0;
Opcode=2'b00;
#T;
$stop;

end   

always_comb begin
 if(reset)
 a_reset: assert final(C == 0);
end

property Addition ;
@(negedge clk ) (Opcode==2'b00 && !reset) |->  (C == (A+B) );
endproperty

property Subtraction ;
@(negedge clk ) (Opcode==2'b01 && !reset) |-> (C == (A-B) );
endproperty

property Inversion_A ;
@(negedge clk ) (Opcode==2'b10 && !reset) |->  (C == (~A) );
endproperty

property Or_B ;
@(negedge clk ) (Opcode==2'b11 && !reset) |->   (C == (|B) );
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