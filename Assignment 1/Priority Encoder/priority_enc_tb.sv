module priority_enc_tb ();

//	Signal Declarations	//
logic [3:0] D;
logic clk,rst;
logic [1:0] Y;
logic valid;

//	Local Parameters	//
localparam T=2;

//	Counters for Summary	//
int Error_Count=0;
int Pass_Count=0;

//	DUT Instantiation	//
priority_enc Priority_Encoder (
        .clk(clk), 
        .rst(rst),
        .D(D),	
        .Y(Y),	
        .valid(valid) );

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
    
// Encoder_1 //
D=4'b1111;
reset_assert;

// Encoder_2 //
D=4'b0000;
check_result(2'bxx,0);

// Encoder_3 //
D=4'b1000;
check_result(2'b00,1);

// Encoder_4 //
D=4'b0100;
check_result(2'b01,1);

D=4'b1100;
check_result(2'b01,1);

// Encoder_5 //
D=4'b0010;
check_result(2'b10,1);

D=4'b0110;
check_result(2'b10,1);

D=4'b1010;
check_result(2'b10,1);

D=4'b1110;
check_result(2'b10,1);

// Encoder_6 //
D=4'b0001;
check_result(2'b11,1);

D=4'b0011;
check_result(2'b11,1);

D=4'b0101;
check_result(2'b11,1);

D=4'b0111;
check_result(2'b11,1);

D=4'b1001;
check_result(2'b11,1);

D=4'b1011;
check_result(2'b11,1);

D=4'b1101;
check_result(2'b11,1);

D=4'b1111;
check_result(2'b11,1);

reset_assert;
$display("TestBench Summary: %d TestCases Failed ,%d TestCases Passed ",Error_Count,Pass_Count);
$stop;
end
// Task For Check the Functionality of Encoder //
task check_result (logic [1:0] Y_Expected,logic valid_Expected);
@(negedge clk);
if(Y_Expected != Y || valid_Expected != valid)
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
rst=1'b1;
check_result(0,0);
rst=1'b0;
endtask

endmodule 
