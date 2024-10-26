// Import Package //
import Counter::*;

// Module Declaration //
module counter_tb ();

// Signals Declarations //
logic clk;
logic rst_n;
logic load_n;
logic up_down;
logic ce;
logic [WIDTH-1:0]data_load; 
logic [WIDTH-1:0]count_out; 
logic max_count ;
logic zero;
logic [WIDTH-1:0] Expected_count_out ;
logic Expected_max_count;
logic Expected_zero;
// Parameters //
localparam T = 2;

// Summary Counters //
int Error_Count=0;
int Pass_Count=0;

// DUT Instantiation //

counter #(.WIDTH(WIDTH)) Counter (.clk(clk),.rst_n(rst_n),.load_n(load_n),.up_down(up_down)
                                 ,.ce(ce),.data_load(data_load),.count_out(count_out)
                                 ,.max_count(max_count),.zero(zero));


// object Creation //
counter_constraints obj=new();

// Clock Generation //
always 
begin    
clk=1'b0;
obj.clk=clk;
#(T/2);
clk=1'b1;
obj.clk=clk;
#(T/2);
end


// Stimulus Generation //
initial begin 

// COUNTER_1 //
reset_assert;   

// COUNTER_2 //
for (int i = 0 ; i<1000 ;i++ ) begin
    assert(obj.randomize());
    rst_n=obj.reset;
    load_n=obj.load;
    up_down=obj.UP_DOWN;
    ce=obj.enable;
    data_load=obj.DATA_LOAD; 
    obj.COUNT_OUT=count_out;
    check_result();
end 
reset_assert;
$display("Testbench Summary : %0d Test Cases Passed , %0d Test Casses Failed",Pass_Count,Error_Count);
$stop;    
end


// Golden Model //
always @ (posedge clk)begin
    if(!rst_n)
    begin
        Expected_count_out<=0;
    end
    else
    begin
        if(!load_n)
        begin
            Expected_count_out<=data_load;
        end
        else if(ce)
        begin
            if(up_down)
                Expected_count_out<=Expected_count_out+1;
            else
                Expected_count_out=Expected_count_out-1;
        end
        
    end
end
assign Expected_zero = (Expected_count_out==0);
assign Expected_max_count=(Expected_count_out == 2**WIDTH-1);
        
// Response Checker //
task check_result ();
@(negedge clk);
if(Expected_count_out != count_out || Expected_max_count != max_count || Expected_zero !=zero)
begin
$display("at time %0d -> Wrong Result. Expected : count_out-> %0d, max_count->%0d,zero->%0d ,Got: %0d,%0d,%0d ",
        $time,Expected_count_out,Expected_max_count,Expected_zero,count_out,max_count,zero);   
Error_Count=Error_Count+1;
end
else 
begin
Pass_Count=Pass_Count+1;    
end

endtask

// Reset //
task reset_assert ();
rst_n=1'b0;
obj.RESET=rst_n;
check_result();
rst_n=1'b1;
obj.RESET=rst_n;
endtask

endmodule