module DSP_tb ();

//  Signals Declartions //
logic clk,rst_n;
logic [17:0] A,B,D;
logic [47:0] C;
logic [47:0] P;

logic [17:0]adder_out;
logic [47:0] mult_out;
logic [47:0] P_Expected;


// Local Parameters //
localparam T = 2;
localparam OPERATION = "ADD";

//  Summary Counters  //
int Pass_Count  =  0;
int Error_Count =  0;

int i=0;

// DUT Instantiation  //
 DSP #(.OPERATION(OPERATION)) dsp(
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .P(P)
 );

//    Clock Generation    //
always 
begin    
clk=1'b0;
#(T/2);
clk=1'b1;
#(T/2);
end

// Stimulus Generation  //

initial 
begin
A=0;
B=0;
C=0;
D=0;   
reset_assert;
        for (i = 0; i < 30; i = i + 1) 
        begin
            A = $random; 
            B = $random; 
            C = $random; 
            D = $random; 
            check_result();           
    end
reset_assert;
$display("Testbench Summary: %d Test Case Pass,%d Test Case Failed",Pass_Count,Error_Count);  
$stop;  
end

// Golden Model //
assign adder_out=B+D;
assign mult_out=adder_out*A;
assign P_Expected=mult_out+C ;

//  Task for Response Checking //
task check_result();
repeat (4)@(negedge clk);
if (P_Expected != P)
    begin
        $display("Test Case Failed: Expected = %d, Got = %d", P_Expected, P);
        Error_Count=Error_Count+1;    
    end
else
    begin
        Pass_Count=Pass_Count+1;
    end

endtask 

// Reset //
task reset_assert;
rst_n=1'b0;
@(negedge clk);
if(P !=0)
begin
     $display("Test Case Failed");   
     Error_Count=Error_Count+1;
end
else
begin
    Pass_Count=Pass_Count+1;
end

rst_n=1'b1;
endtask 

endmodule