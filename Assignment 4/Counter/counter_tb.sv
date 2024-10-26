// Import Package //
import Counter::*;

// Module Declaration //
module counter_tb (Counter_Interface.TEST counter_if);

// object Creation //
counter_constraints obj=new();
// Stimulus Generation //
always_comb begin
obj.clk=counter_if.clk;
end

initial begin 

// COUNTER_1 //
counter_if.rst_n=0;
@(negedge counter_if.clk)
#1;
counter_if.rst_n=1;

// COUNTER_2 //
for (int i = 0 ; i<10000 ;i++ ) begin
    randomizing_a:assert(obj.randomize());
    counter_if.rst_n=obj.reset;
    counter_if.load_n=obj.load;
    counter_if.up_down=obj.UP_DOWN;
    counter_if.ce=obj.enable;
    counter_if.data_load=obj.DATA_LOAD; 
    obj.COUNT_OUT=counter_if.count_out;
    @(negedge counter_if.clk)
    #1;
end 

counter_if.rst_n=0;
@(negedge counter_if.clk)
#1;
counter_if.rst_n=1;
@(negedge counter_if.clk)
#1;
$stop;    
end

endmodule