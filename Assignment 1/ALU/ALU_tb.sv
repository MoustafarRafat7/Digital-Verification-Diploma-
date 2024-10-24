module ALU_tb();
//   Signals Declrations     //
logic clk,reset;
logic [1:0]Opcode;
logic signed [3:0] A,B;
logic signed [4:0] C;

//   Local Parameters    //
localparam T = 2;
localparam MAXPOS=7;
localparam MAXNEG=-8;
localparam Zero =0 ;

//	Counters for Summary	//
int Error_Count=0;
int Pass_Count=0;


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
reset_assert;

// ALU_Addition_2 //
Opcode=2'b00;
A=MAXPOS;
B=MAXPOS;
check_result(14);

// ALU_Addition_3 //
A=MAXNEG;
B=MAXNEG;
check_result(-16);

// ALU_Addition_4 //
A=Zero;
B=Zero;
check_result(0);

// ALU_Addition_5 //
A=MAXPOS;
B=MAXNEG;
check_result(-1);

// ALU_Addition_6 //
A=MAXPOS;
B=Zero;
check_result(7);

// ALU_Addition_7 //
A=MAXNEG;
B=MAXPOS;
check_result(-1);

// ALU_Addition_8 //
A=MAXNEG;
B=Zero;
check_result(-8);

// ALU_Addition_9 //
A=Zero;
B=MAXPOS;
check_result(7);

// ALU_Addition_10 //
A=Zero;
B=MAXNEG;
check_result(-8);

// ALU_Subtraction_11 //
Opcode=2'b01;
A=MAXPOS;
B=MAXPOS;
check_result(0);

// ALU_Subtraction_12 //
A=MAXNEG;
B=MAXNEG;
check_result(0);

// ALU_Subtraction_13 //
A=Zero;
B=Zero;
check_result(0);

// ALU_Subtraction_14 //
A=MAXPOS;
B=MAXNEG;
check_result(15);

// ALU_Subtraction_15 //
A=MAXPOS;
B=Zero;
check_result(7);

// ALU_Subtraction_16 //
A=MAXNEG;
B=MAXPOS;
check_result(-15);

// ALU_Subtraction_17 //
A=MAXNEG;
B=Zero;
check_result(-8);

// ALU_Subtraction_18 //
A=Zero;
B=MAXPOS;
check_result(-7);

// ALU_Subtraction_19 //
A=Zero;
B=MAXNEG;
check_result(8);

// ALU_Inversion_20 //
Opcode=2'b10;
A=Zero;
check_result(5'b11111);

// ALU_Inversion_21 //
A=4'b1111;
check_result(Zero);

// ALU_Inversion_22  //
A=MAXPOS;
check_result(5'b11000);

// ALU_Inversion_23  //
A=MAXNEG;
check_result(5'b00111);

// ALU_Rediction_OR_24 //
Opcode=2'b11;
B=MAXNEG;
check_result(1);

// ALU_Rediction_OR_25 //
B=MAXPOS;
check_result(1);

// ALU_Rediction_OR_26 //
B=4'b1100;
check_result(1);

// ALU_Rediction_OR_27 //
B=4'b0001;
check_result(1);

// ALU_Rediction_OR_28 //
B=Zero;
check_result(Zero);

// ALU_Rediction_OR_29 //
B=4'b1111;
check_result(1);

reset_assert;
Opcode=2'b00;
#T;

$display("TestBench Summary:%d TestCases Failed ,%d TestCases Passed ",Error_Count,Pass_Count);
$stop;

end   

task check_result (logic signed [4:0] C_Expected);
@(negedge clk);
if( C_Expected != C )
begin
$display("Test Case Failed");
Error_Count=Error_Count+1;
end
else
begin
Pass_Count=Pass_Count+1;
end
endtask

// Task For Reset Functionality //
task reset_assert;
reset=1'b1;
check_result(0);
reset=1'b0;
endtask


endmodule