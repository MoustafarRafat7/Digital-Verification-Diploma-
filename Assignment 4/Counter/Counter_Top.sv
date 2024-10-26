module Counter_Top ();

bit clk;

// Clock Generation //
always 
begin    
clk=1'b0;
#2;
clk=1'b1;
#2;
end

Counter_Interface counter_if(clk);
counter Counter_Design (counter_if);
counter_tb Counter_testbench(counter_if);
bind counter Counter_SVA counter_SVA(counter_if);


endmodule