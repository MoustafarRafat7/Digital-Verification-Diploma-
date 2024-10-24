module priority_enc (
input  clk,
input  rst,
input  [3:0] D,	
output reg  [1:0] Y,	
output reg valid
);

always @(posedge clk) begin
  if (rst)
	begin
    	Y <= 2'b00;    //1st bug : outputs Y and valid should be reg as they assigned in always block to fix this they should be reg as it's assigned in always block
		valid<=1'b0;   //2nd bug : valid should be zero when rst is asserted @posedge of clk 
	end
  else
	begin
  		casex (D)
  			4'b1000: Y <= 0;
  			4'bX100: Y <= 1;
  			4'bXX10: Y <= 2;
  			4'bXXX1: Y <= 3;
			default: Y <= 0 ;  //adding default case to deal with the rest of input combinations.
  		endcase
  		valid <= (~|D)? 1'b0: 1'b1;  //3rd bug that else should have begin and end
	end	
end
endmodule
