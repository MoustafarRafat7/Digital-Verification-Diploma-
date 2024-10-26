module Counter_SVA(Counter_Interface.DUT counter_if);

property load_signal;
@(posedge counter_if.clk)  disable iff (!counter_if.rst_n) (!counter_if.load_n) |=> ($past(counter_if.data_load) == counter_if.count_out);
endproperty

property load_off_enable_off;
@(posedge counter_if.clk)  disable iff (!counter_if.rst_n) ( (counter_if.load_n) && (!counter_if.ce) ) |=> 
                                                                      ( counter_if.count_out == $past(counter_if.count_out) );
endproperty

property Count_UP;
@(posedge counter_if.clk) disable iff (!counter_if.rst_n) ( (counter_if.load_n) && (counter_if.ce) && (counter_if.up_down) )  |=> 
                                                                    (counter_if.count_out == ($past(counter_if.count_out) + 1'b1 ) ) ;
endproperty

property Count_Down;
@(posedge counter_if.clk) disable iff (!counter_if.rst_n) ( (counter_if.load_n) && (counter_if.ce) && (!counter_if.up_down) ) |=>  
                                                                       ( counter_if.count_out == ($past(counter_if.count_out) - 1'b1 ) ) ;
endproperty

always_comb begin
if  (counter_if.count_out == 1'b0) 
zero_a:assert (counter_if.zero==1'b1); 
end

always_comb begin
if  (counter_if.count_out == (2**counter_if.WIDTH)-1'b1) 
Max_count_a:assert ( (counter_if.max_count) ==1'b1); 
end

always_comb begin
 if(!counter_if.rst_n)
 a_reset: assert final(counter_if.count_out == 0);
end



load_assert: assert property (load_signal);
load_cover : cover  property  (load_signal);

No_Change_assert: assert property (load_off_enable_off);
No_Change_cover : cover  property  (load_off_enable_off);

increment_assert: assert property (Count_UP);
increment_cover : cover  property  (Count_UP);

Decrement_assert: assert property (Count_Down);
Decrement_cover : cover  property  (Count_Down);




endmodule 