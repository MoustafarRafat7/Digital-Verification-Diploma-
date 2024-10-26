module priority_enc_tb ();

//	Signal Declarations	//
logic [3:0] D;
logic clk,rst;
logic [1:0] Y;
logic valid;

//	Local Parameters	//
localparam T=4;


//	DUT Instantiation	//
priority_enc Priority_Encoder (
        .clk(clk), 
        .rst(rst),
        .D(D),	
        .Y(Y),	
        .valid(valid) );

//	Clock  Generation	//	
always 
begin
clk=1'b0;
#(T/2);
clk=1'b1;
#(T/2);
end

//	Test Generation		//	
initial
begin
    
// Encoder_1 //
D=4'b1111;
rst=1'b1;
// Encoder_2 //
@(negedge clk);
rst=1'b0;
D=4'b0000;

// Encoder_3 //
@(negedge clk);
D=4'b1000;

// Encoder_4 //
@(negedge clk);
D=4'b0100;

@(negedge clk);
D=4'b1100;

// Encoder_5 //
@(negedge clk);
D=4'b0010;

@(negedge clk);
D=4'b0110;

@(negedge clk);
D=4'b1010;

@(negedge clk);
D=4'b1110;

// Encoder_6 //
@(negedge clk);
D=4'b0001;

@(negedge clk);
D=4'b0011;

@(negedge clk);
D=4'b0101;

@(negedge clk);
D=4'b0111;

@(negedge clk);
D=4'b1001;

@(negedge clk);
D=4'b1011;

@(negedge clk);
D=4'b1101;

@(negedge clk);
D=4'b1111;

@(negedge clk);
rst=1'b1;
// Encoder_2 //
@(negedge clk);
rst=1'b0;

$stop;
end

initial begin
    $monitor("clk = %b , rst = %b , D = %b , valid = %b, Y = %b",clk, rst,D,valid,Y);
  end

property reset_p;
@(posedge clk) rst |=> ( Y == 0 && valid == 0);
endproperty

assert property (reset_p);
cover property (reset_p);

property enc_none ;
@(posedge clk) (D==0000 && !rst) |=> ( Y == 0 && valid == 0);
endproperty

property enc_3 ;
@(posedge clk) (D[3] && !D[2] && !D[1] && !D[0] && !rst) |=> ( Y == 0 && valid == 1);
endproperty

property enc_2 ;
@(posedge clk) (D[2] && !D[1] && !D[0] && !rst) |=> ( Y == 1 && valid == 1);
endproperty

property enc_1 ;
@(posedge clk) (D[1] && !D[0] && !rst) |=> ( Y == 2 && valid == 1);
endproperty

property enc_0 ;
@(posedge clk) (D[0] && !rst ) |=> ( Y == 3 && valid == 1);
endproperty

assert property (enc_none);
cover property (enc_none);

assert property (enc_3);
cover property (enc_3);

assert property (enc_2);
cover property (enc_2);

assert property (enc_1);
cover property (enc_1);

assert property (enc_0);
cover property (enc_0);



endmodule 
