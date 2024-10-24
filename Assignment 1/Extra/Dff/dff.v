module dff(clk, rst, d, q, en);
parameter USE_EN = 1;
input clk, rst, d, en;
output reg q;

always @(posedge clk) begin 
   if (rst)
      q <= 0;
   else
      if(USE_EN)
	begin       //Adding begin and end in that if condition
         if (en)
            q <= d;
         else
            q <= q;  //1st bug : this line assigns d to q ,then fixed to keep the same value when en =0.
	end
      else 
         q <= d;
end 

endmodule
