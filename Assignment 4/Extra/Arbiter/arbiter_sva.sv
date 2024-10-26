/*2. Write SVA properties for an arbiter design for the following specs:
1- Upon rising of the signal “request” by a master, the arbiter should raise the “grant” within 2 to 5 clock 
cycles.
2- Once the “grant” is raised, the master should acknowledge acceptance in the same clock cycle by lowering
the "frame" and "irdy" signals.
3- Once the master completes the transaction it raises the "frame" and "irdy" signals, followed by that, the 
arbiter should lower the "grant" signal on the next clock cycle.*/

module  arbiter();

property arbiter_1;
@(posedge clk ) $rose(request) |-> ##[2:5] $rose(grant);
endproperty

property arbiter_2;
@(posedge clk ) $rose(grant) |-> $fell(frame) ##0 $fell(irdy);
endproperty

property arbiter_3;
@(posedge clk ) $rose(frame) ##0 $rose(irdy) |=> $fell(grant);
endproperty



endmodule