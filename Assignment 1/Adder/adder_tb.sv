module adder_tb();
//	Signal Declarations	//
reg clk;
reg reset;
reg signed [3:0] A;	// Input data A in 2's complement
reg signed [3:0] B; 	// Input data B in 2's complement
wire signed [4:0] C;    // Adder output in 2's complement

//	Local Parameters	//

localparam T=2; //local parameters can't be overwritten
localparam MAXPOS = 7;
localparam MAXNEG = -8;


//	Counters for Summary	//
int Error_Count=0;
int Pass_Count=0;

//	DUT Instantiation	//
adder Adder(.clk(clk),.reset(reset),.A(A),.B(B),.C(C));


//	Clock  Generation	//	
always 
begin
clk=1'b0;
#(T/2);
clk=1'b1;
#(T/2);
end
//	Test Generation		//	
initial
begin
A=1;
B=0;
reset_assert();

A=MAXPOS;
B=MAXPOS;
check_result(14);

A=0;
B=MAXPOS;
check_result(7);

A=MAXNEG;
B=MAXPOS;
check_result(-1);

B=0;
A=MAXPOS;
check_result(7);

B=MAXNEG;
A=MAXPOS;
check_result(-1);

A=MAXNEG;
B=MAXNEG;
check_result(-16);

A=0;
B=MAXNEG;
check_result(-8);

B=0;
A=MAXNEG;
check_result(-8);

B=0;
A=0;
check_result(0);
reset=1'b1;
#T;
$display("TestBench Summary: %d TestCases Failed ,%d TestCases Passed ",Error_Count,Pass_Count);
$stop;
end

//	why these tests ?..	boundary may have problems such as OF ,UF etc..		//

task check_result (logic signed [4:0] expected_result);
@(negedge clk); // delay
if(expected_result != C) // checking
begin
$display("Wrong Result:Expected output %d is not equal to  dut output -> %d ",expected_result,C);
Error_Count=Error_Count+1;
end
else
Pass_Count=Pass_Count+1;
endtask

task reset_assert();
reset=1'b1;
check_result(0);
reset=1'b0;
endtask

endmodule