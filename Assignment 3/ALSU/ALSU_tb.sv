// Import the package //
import ALSU_Package::*;

// Module Delaration //
module ALSU_tb(); 

// Signals Declaration //
// inputs //
logic clk,reset;
logic signed [2:0] A,B;
logic cin;
logic serial_in;
logic red_op_A,red_op_B;
opcode_e opcode;
logic bypass_A,bypass_B;
logic direction;

// internals //
logic signed [2:0] A_REG,B_REG;
logic signed [1:0]cin_reg;
logic serial_in_reg;
logic red_op_A_reg,red_op_B_reg;
logic bypass_A_reg,bypass_B_reg;
opcode_e opcode_reg;
logic direction_reg;
logic signed [5:0] Expected_out;
logic [15:0]Expected_leds;

logic invalid_red_op, invalid_opcode, invalid;

// Outputs //
logic [15:0]leds;
logic signed [5:0]out;

// Summary Counters //
int Pass_Count=0;
int Error_Count=0;

// DUT Instantiation //

ALSU alsu (.clk(clk)
          ,.rst(reset)
          ,.A(A)
          ,.B(B)
          ,.cin(cin)
          ,.serial_in(serial_in)
          ,.red_op_A(red_op_A)
          ,.red_op_B(red_op_B)
          ,.opcode(opcode)
          ,.bypass_A(bypass_A)
          ,.bypass_B(bypass_B)
          ,.direction(direction)
          ,.out(out)
          ,.leds(leds)
);


// Clock Generation //
always begin
    clk=1'b0;
    #(T/2);
    clk=1'b1;
    #(T/2);
end


ALSU_Constraints obj=new();

// Stimulus Generation //
initial begin

reset_assert;

obj.arr_cons.constraint_mode(0);

// First loop //
for (int i = 0; i<75000;i++ ) begin
    assert(obj.randomize());
    reset=obj.Reset;
    A=obj.a;
    B=obj.b;
    cin=obj.CIN;
    serial_in=obj.SERIAL_IN;
    red_op_A=obj.RED_OP_A;
    red_op_B=obj.RED_OP_B;
    opcode=obj.OPCODE;
    bypass_A=obj.BYPASS_A;
    bypass_B=obj.BYPASS_B;
    direction=obj.DIRECTION;
    check_result();
    sampling(obj);
end    

obj.constraint_mode(0);
obj.arr_cons.constraint_mode(1);

reset=1'b0;
bypass_A=1'b0;
bypass_B=1'b0;
red_op_A=1'b0;
red_op_B=1'b0;

// Second Loop //
for (int n = 0; n<1000 ;n++ ) begin
    assert(obj.randomize());
    A=obj.a;
    B=obj.b;
    cin=obj.CIN;
    serial_in=obj.SERIAL_IN;
    direction=obj.DIRECTION;
    for (int j = 0; j<6 ;j++ ) begin
    obj.OPCODE=obj.arr[j];    
    opcode= obj.arr[j];
    check_result();
    sampling(obj);
    end
end    

$display("Testbench Summary: %0d Test cases Passed , %0d Test Cases Failed",Pass_Count,Error_Count);
$stop;
end

// Golden Model //
always @(posedge clk , posedge reset)
begin
    if(reset)
    begin
        Expected_leds<=16'b0;
        A_REG<=0;
        B_REG<=0;
        cin_reg<=0;
        serial_in_reg<=0;
        red_op_A_reg<=0;
        red_op_B_reg<=0;
        bypass_A_reg<=0;
        bypass_B_reg<=0;
        opcode_reg<=opcode_e'(0);
        direction_reg<=0;
        Expected_out<=0;
    end
    else
    begin
        A_REG<=A;
        B_REG<=B;
        cin_reg<=cin;
        serial_in_reg<=serial_in;
        red_op_A_reg<=red_op_A;
        red_op_B_reg<=red_op_B;
        bypass_A_reg<=bypass_A;
        bypass_B_reg<=bypass_B;
        opcode_reg<=opcode;
        direction_reg<=direction;
        if(invalid)
        begin
            Expected_leds<=~Expected_leds;
        end
        else 
        Expected_leds<=0;
    end
end

always @(posedge clk ,posedge reset) begin
    if(reset)
     Expected_out<=0;
      else begin 
       if (bypass_A_reg && bypass_B_reg)
        begin
            if(INPUT_PRIORITY == "A")
            Expected_out<=A_REG;
            else 
            Expected_out<=B_REG;
        end
        else if(bypass_A_reg) begin
        Expected_out<=A_REG;
        end
        else if (bypass_B_reg) begin
        Expected_out<=B_REG;
         end
    
         else if (invalid)
        begin
         Expected_out<=0;
        end
        else begin
        case (opcode_e'(opcode_reg))
        OR:
        begin
            if ((red_op_A_reg && red_op_B_reg)) begin 
                if(INPUT_PRIORITY == "A") 
                     Expected_out<=  |A_REG;
                else     
                     Expected_out<=  |B_REG;
             end
            else if(red_op_A_reg)
                 Expected_out<=  |A_REG;
            else if(red_op_B_reg)
                 Expected_out<=  |B_REG;
            else 
                 Expected_out<= A_REG | B_REG;
        end
    XOR:
        begin
            if (red_op_A_reg && red_op_B_reg) begin
                if(INPUT_PRIORITY == "A")
                    Expected_out<= ^A_REG;
                else 
                    Expected_out<= ^B_REG;
            end
            else if(red_op_A_reg)
             Expected_out<= ^A_REG;
            else if(red_op_B_reg)
             Expected_out<= ^B_REG;
            else 
                 Expected_out<= A_REG ^ B_REG;
        end

    ADD:
        begin
         if(FULL_ADDER =="ON")
          Expected_out<=A_REG+B_REG+cin_reg;   
         else
          Expected_out<=A_REG+B_REG;
        end
    MULT:
        begin
          Expected_out<= A_REG*B_REG;   
        end
    SHIFT:
         begin
            if(direction_reg)begin
                 Expected_out<= {Expected_out[4:0],serial_in_reg};
            end
            else begin
                 Expected_out<= {serial_in_reg, Expected_out[5:1]};
            end
         end
    ROTATE:
          begin
            if(direction_reg)begin
                 Expected_out<= { Expected_out[4:0], Expected_out[5]};
            end
            else begin
                 Expected_out<= { Expected_out[0], Expected_out[5:1]};
            end
          end
    endcase 
     end
end
end
//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[2] | opcode_reg[1]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;



// Response Checker //
task check_result();
repeat(2)@(negedge clk);
if (Expected_out != out || Expected_leds != leds) begin
    Error_Count=Error_Count+1;
end

else begin
    Pass_Count=Pass_Count+1;
end

endtask

// Reset //
task reset_assert();
reset=1'b1;
@(negedge clk);
if(out != Expected_out || Expected_leds != leds)
begin
$display("Reset Failed");    
Error_Count=Error_Count+1;    
end
else begin
Pass_Count=Pass_Count+1;
reset=1'b0;
end
endtask


task sampling (ALSU_Constraints obj_t);
       if(reset || bypass_A || bypass_B)
        obj_t.cvr_gp.stop();
        else begin
        obj_t.cvr_gp.start();
        obj_t.cvr_gp.sample();
        end
endtask 

endmodule