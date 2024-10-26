// Import the Package //
import ALU_Package::*;

// Module Declaration //
module ALU_tb();

//   Signals Declrations     //
logic clk,reset;
opcode_t Opcode;
logic signed [3:0] A,B;
logic signed [4:0] C;

logic signed [4:0] C_Expected;

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

// Object Creation //

ALU_Constraints obj=new();

//	Stimulus Generation		//	
initial
begin

// ALU_reset_1 //
reset_assert;
// ALU_2 //
repeat(20)  begin
    assert(obj.randomize());
    A=obj.a;
    B=obj.b;
    reset=obj.RESET;
    Opcode=obj.OPCODE;
    check_result();
end

reset_assert;
$display("TestBench Summary:%d TestCases Failed ,%d TestCases Passed ",Error_Count,Pass_Count);
$stop;

end   

// Golden Model //
always @(posedge clk,posedge reset)
begin
    if(reset)
    begin
       C_Expected<=0;
    end
    else
	begin
    case (Opcode)
        Add:C_Expected<=A+B;
        Sub:C_Expected<=A-B;
        invert_A:C_Expected<=~A;
        reduction_OR_B: C_Expected<=|B;
    endcase
	end
    
end

// Response Checker //
task check_result ();
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
check_result();
reset=1'b0;
endtask


endmodule