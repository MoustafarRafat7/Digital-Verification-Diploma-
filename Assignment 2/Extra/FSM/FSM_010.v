////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: 010-sequence-detector Design 
//
////////////////////////////////////////////////////////////////////////////////
module FSM_010(clk, rst, x, y, count);
	parameter IDLE  = 2'b00;
	parameter ZERO  = 2'b01;
	parameter ONE   = 2'b10;
	parameter STORE = 2'b11; 

	input clk, rst, x;
	output y;
	output reg [9:0] count; // count not user_count.

	reg [1:0] cs, ns;

	always @(*) begin
		case (cs)
			IDLE:begin    //Missing begin & end in each case 
				if (x)
					ns = IDLE;
				else 
					ns = ZERO;
				end
			ZERO:begin
				if (x)
					ns = ONE;
				else 
					ns = ZERO;
				end
			ONE:begin 
				if (x)
					ns = IDLE;
				else 
					ns = STORE;
				end
			STORE:begin 
				if (x)
					ns = IDLE;
				else 
					ns = ZERO;
				end	
			default: 	ns = IDLE;
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			cs <= IDLE;
		end
		else begin
			cs <= ns;
		end
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			count <= 0;
		end
		else begin
			if (cs == STORE)
				count <= count + 1;
		end
	end

	assign y = (cs == STORE)? 1:0;

    
endmodule