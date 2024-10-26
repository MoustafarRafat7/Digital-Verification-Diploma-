////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (Counter_Interface.DUT counter_if);


always @(posedge counter_if.clk,negedge counter_if.rst_n) begin
    if (!counter_if.rst_n)
        counter_if.count_out <= 0;
    else if (!counter_if.load_n)
        counter_if.count_out <= counter_if.data_load;
    else if (counter_if.ce)
        if (counter_if.up_down)
            counter_if.count_out <= counter_if.count_out + 1'b1;
        else 
            counter_if.count_out <= counter_if.count_out - 1'b1;
end

assign counter_if.max_count = (counter_if.count_out == {counter_if.WIDTH{1'b1}})? 1:0;
assign counter_if.zero = (counter_if.count_out == 0)? 1:0;

endmodule