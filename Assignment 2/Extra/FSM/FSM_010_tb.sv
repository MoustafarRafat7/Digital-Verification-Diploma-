// Import Package //
import FSM ::*;

// Module Declaration //
module FSM_010_tb (
);

// Signals Declaration //
// Input Ports //
logic clk,rst;
logic x;

// Output Ports //
logic y;
logic [9:0]count;

// Internal Reg //
state_e Current_State,Next_State;

// Expected Outputs //
logic Expected_y;
logic [9:0]Expected_count;

//Summary Counters //
int Error_Count=0;
int Pass_Count=0;

// DUT Instantiation //
FSM_010 fsm_010(.clk(clk)
               ,.rst(rst)
               ,.x(x)
               ,.y(y)
               ,.count(count)
);

// Clock Generation //
always begin
    clk=1'b0;
    #(T/2);
    clk=1'b1;
    #(T/2); 
end

//Object Creation //
fsm_transaction obj=new();

// Stimulus Generation //

initial begin
  
    // FSM_1 //
  reset_assert();

   // FSM_2 //
  for (int i =0 ;i<1000 ;i++ ) begin
  assert(obj.randomize());
  rst=obj.rst;
  x=obj.x; 
  check_result();
  end
reset_assert;
$display("Testbench Summary: %0d Test Cases Passed , %0d Test Cases Failed",Pass_Count,Error_Count);
$stop;
end

// Golden Model //

always @(posedge clk ,posedge rst)
begin
    if(rst) begin
        Expected_count<=0;
        Current_State<=IDLE;
    end
    else begin
        Current_State<=Next_State;
    end
    if(Current_State == STORE)
    Expected_count=Expected_count+1;
end

always @(*) begin
    case(Current_State)
    IDLE:begin
            if(x)
                Next_State=IDLE;
            else
                Next_State=ZERO;
        end
    ZERO:begin
            if(x)
                Next_State=ONE;
            else
                Next_State=ZERO;
        end
    ONE:begin
            if(x)
                Next_State=IDLE;
            else
                Next_State=STORE;
        end
    STORE:begin
            if(x)
                Next_State=IDLE;
            else
                Next_State=ZERO;
        end

    endcase
end
    
always @(*) begin
    case(Current_State)
    IDLE:Expected_y=0;
    ZERO:Expected_y=0;
    ONE:Expected_y=0;
    STORE:Expected_y=1;
    endcase
end
    
// Response  Checker //
task check_result();
@(negedge clk);
if(y != Expected_y)
Error_Count=Error_Count+1;
else
Pass_Count=Pass_Count+1;
endtask

// Reset //
task reset_assert ();
rst=1'b1;
check_result();
rst=1'b0;
endtask
    
endmodule