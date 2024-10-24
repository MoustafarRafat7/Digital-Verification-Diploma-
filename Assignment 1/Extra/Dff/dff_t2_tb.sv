module dff_t2_tb ();

//  Signals Declartions //
logic clk,rst;
logic d, en;
logic q;

// Local Parameters     //
localparam T = 2;
localparam USE_EN=0;

// Summary Counters     //
int Pass_Count  = 0;
int Error_Count = 0;

//  DUT Instantiation   //

dff #(.USE_EN(0))DFF (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
);

//  Clock Generation    //
always
begin
#(T/2);
clk=~clk;    
end

//  Stimulus Generation //
initial
begin
clk=0;
//  DFF_1   //
reset_assert;

//  DFF_2   //
d=1'b0;
en=1'b1;
check_result(0);

//  DFF_3   //
d=1'b1;
en=1'b0;
check_result(1);

//  DFF_4   //
d=1'b0;
en=1'b0;
check_result(0);
//  DFF_5   //
d=1'b1;
en=1'b1;
check_result(1);

reset_assert;
$display("TestBench Summary:%d TestCases Failed ,%d TestCases Passed ",Error_Count,Pass_Count);
$stop;

end

// Check Functionality //
task check_result(logic q_Expected);
@(negedge clk);
if( q_Expected != q )
begin
$display("Test Case Failed");
Error_Count=Error_Count+1;
end
else
begin
Pass_Count=Pass_Count+1;
end
endtask

// Reset Functionality Check    //
task reset_assert;
rst=1'b1;
check_result(0);
rst=1'b0;
endtask 

endmodule