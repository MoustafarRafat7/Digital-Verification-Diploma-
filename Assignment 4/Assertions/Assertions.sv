module  Assertions();

/*Write assert property statement, if signal a is high in a positive edge of a clock then 
signal b should be high after 2 clock cycle*/

Property1:assert property ( (@posedge clk) a |-> ##2 b );

/*Write assert property statement, If signal a is high and signal b is high then signal c 
should be high 1 to 3 clock cycle later*/

Property2:assert property ( (@posedge clk) (a&&b) |-> ##1 c[*1:3] );

/*3) Write a sequence s11b, after 2 positive clock edges, signal b should be low*/

sequence s11b
@(posedge clk) ##2 !b;
endsequence

/*4) Write a property for the following specs:
- 3-to-8 decoder output Y
i. At each positive edge of clock, Y output must be only one bit high.
- 4-to-2 priority encoder output valid (refer to assignment 1)
i. At each positive edge of clock, if the input D bits are low then after one 
clock cycle, output valid must be low.*/

property onhot_prop;
@(posedge clk ) $onehot(y);
endproperty

property encoder;
@(posedge clk) !D |=> !valid;
endproperty

endmodule