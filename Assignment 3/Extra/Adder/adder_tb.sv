import Adder_Package::*;

module adder_tb();
//	Signal Declarations	//
reg clk;
reg reset;
reg signed [3:0] A;	// Input data A in 2's complement
reg signed [3:0] B; 	// Input data B in 2's complement
wire signed [4:0] C;    // Adder output in 2's complement

//	Local Parameters	//

localparam T=2; //local parameters can't be overwritten

//	Counters for Summary	//
int Error_Count=0;
int Pass_Count=0;

//	DUT Instantiation	//
adder Adder(.clk(clk),.reset(reset),.A(A),.B(B),.C(C));

// Object //
Transaction obj=new();


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
reset_assert(obj);

for (int i  =0 ;i<110 ;i++ ) begin
    assert(obj.randomize());
    reset=obj.RESET;
    A=obj.A;
    B=obj.B;
    if(!reset)
    check_result(A+B);
    else
    check_result(0);

    sampling(obj);
end

reset_assert(obj);

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

task reset_assert(Transaction tr);
reset=1'b1;
tr.RESET=reset;
check_result(0);
reset=1'b0;
tr.RESET=reset;
endtask

task sampling (Transaction tr);
if(tr.RESET) begin
tr.Covgrp_A.stop();
tr.Covgrp_B.stop();
end
else begin
tr.Covgrp_A.start();
tr.Covgrp_B.start();
tr.Covgrp_A.sample();
tr.Covgrp_B.sample();
    
end

endtask

endmodule