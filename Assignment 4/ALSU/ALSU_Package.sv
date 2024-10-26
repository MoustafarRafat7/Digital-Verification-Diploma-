package ALSU_Package;

// Enums //
typedef enum {OR=0,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7}opcode_e;

// Parameters //
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
parameter MAXPOS=3;
parameter ZERO=0;
parameter MAXNEG=-4;
parameter T=2;

// Class //
class ALSU_Constraints;

// Class Variables //
rand logic Reset;
rand logic signed [2:0] a,b;
rand logic BYPASS_A,BYPASS_B;
rand opcode_e OPCODE; 
rand logic CIN;
rand logic RED_OP_A,RED_OP_B;
rand logic SERIAL_IN;
rand logic DIRECTION;
rand opcode_e arr [6];
// Constraints block //

constraint Reset_Cons {

    //Reset to be asserted with a low probability//
    Reset dist {1:=1,0:=99}; 
}

constraint bypass_Cons{
    // bypass_A and bypass_B should be disabled most of the time //
    BYPASS_A dist {1:=4,0:=96};
    BYPASS_B dist {1:=4,0:=96};
}
constraint invalid_opcode_Cons {    
    // Invalid cases should occur less frequent than the valid cases //
    OPCODE dist {INVALID_6:/2,INVALID_7:/2,[0:5]:/96};
}

constraint ADD_MULT_opcode{
    // in case of addition or multiplication inputs (A, B) to take the values (MAXPOS, ZERO and MAXNEG) more often than others //
    if( OPCODE == ADD || OPCODE == MULT )
    {
    a dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    b dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    }
}

constraint OR_XOR_opcode_A{
     if(OPCODE == OR || OPCODE == XOR)
    {
        if (RED_OP_A) {
            a dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2} ;
            b == 0;
        }
    }
}
constraint OR_XOR_opcode_B{
     if (RED_OP_B) {
            b dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2}  ;
            a == 0;
        }
}

constraint arr_cons {
    unique{arr};
foreach(arr[j])
arr[j] inside {[OR:ROTATE]};
}


// Functional Coverage //
covergroup cvr_gp ;
A_cp:coverpoint a {
                    bins A_data_0 ={ZERO};
                    bins A_data_max= {MAXPOS};
                    bins A_data_min= {MAXNEG};
                    bins A_data_default =default;
}
A_cp1:coverpoint a  iff (RED_OP_A) {bins A_data_walkingones []={3'b001,3'b010,3'b100};}

B_cp:coverpoint b {
                    bins B_data_0 ={ZERO};
                    bins B_data_max= {MAXPOS};
                    bins B_data_min= {MAXNEG};
                    bins B_data_default =default;
}
B_cp1:coverpoint b  iff (!RED_OP_A && RED_OP_B) {bins B_data_walkingones []={3'b001,3'b010,3'b100};}

ALU_cp:coverpoint OPCODE {
                         bins Bins_shift[] = {SHIFT,ROTATE};
                         bins Bins_arith[] = {ADD,MULT};
                         bins Bins_bitwise[] = {OR,XOR};
                         illegal_bins Bins_invalid[]={INVALID_6,INVALID_7};
                         bins Bins_trans=(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
}

Cin_cp:coverpoint CIN {bins cin_zero_one = {0,1};} 
Shift_in_cp:coverpoint SERIAL_IN {bins SERIAL_IN_zero_one = {0,1};} 
Direction_cp:coverpoint DIRECTION {bins Direction_zero_one = {0,1};}
RED_OP_A_cp:coverpoint RED_OP_A {bins reduction_a_0={0};
                                 bins reduction_a_1={1};
}
RED_OP_B_cp:coverpoint RED_OP_B {bins reduction_b_0={0};
                                 bins reduction_b_1={1};
}

ADD_MULT_A_B_Zero_MaxP_N:cross  ALU_cp,A_cp,B_cp {
                                bins mult_add_a_b= binsof(ALU_cp.Bins_arith);
                                option.cross_auto_bin_max=0;
}
ADD_CIN: cross Cin_cp,ALU_cp {
                bins Cin_Add_zero_one = binsof(ALU_cp) intersect {ADD} && binsof(Cin_cp.cin_zero_one);
                option.cross_auto_bin_max=0;
}

Shift_Serial_in :cross Shift_in_cp,ALU_cp {
                bins Shift_in_zero_one = binsof(ALU_cp) intersect {SHIFT} && binsof(Shift_in_cp.SERIAL_IN_zero_one);
                option.cross_auto_bin_max=0;
}

ROT_SHIFT_Direction :cross Direction_cp,ALU_cp {
                bins Direction_ROT_Shift_zero_one = binsof(ALU_cp.Bins_shift) && binsof(Direction_cp.Direction_zero_one);
                option.cross_auto_bin_max=0;
}

cross_5: cross  ALU_cp,A_cp1,B_cp {
                bins A_data_walkingones_b_zero = binsof(ALU_cp.Bins_bitwise) && binsof(A_cp1.A_data_walkingones) && binsof(B_cp.B_data_0) ;
                option.cross_auto_bin_max=0;
}
cross_6: cross  ALU_cp,B_cp1,A_cp {
                bins B_data_walkingones_A_zero = binsof(ALU_cp.Bins_bitwise) && binsof(B_cp1.B_data_walkingones) && binsof(A_cp.A_data_0) ;
                option.cross_auto_bin_max=0;
}

Invalid_OR_XOR: cross ALU_cp,RED_OP_A_cp,RED_OP_B_cp {
                      bins invalid_reduction_A = ( binsof(ALU_cp.Bins_shift) || binsof(ALU_cp.Bins_arith) ) && binsof(RED_OP_A_cp.reduction_a_1);
                      bins invalid_reduction_B = ( binsof(ALU_cp.Bins_shift) || binsof(ALU_cp.Bins_arith) ) && binsof(RED_OP_B_cp.reduction_b_1);
                      option.cross_auto_bin_max=0;

                     /* bins invalid_reduction_A_shift =  binsof(ALU_cp.Bins_shift) &&  binsof(RED_OP_A_cp.reduction_a_1);
                      bins invalid_reduction_A_arith =  binsof(ALU_cp.Bins_arith) &&  binsof(RED_OP_A_cp.reduction_a_1);
                      bins invalid_reduction_B_shift =  binsof(ALU_cp.Bins_shift) &&  binsof(RED_OP_B_cp.reduction_b_1);
                      bins invalid_reduction_B_arith =  binsof(ALU_cp.Bins_arith) &&  binsof(RED_OP_B_cp.reduction_b_1);
                     */
}
endgroup

function new();
   
   cvr_gp =new() ;
    
endfunction

endclass

endpackage