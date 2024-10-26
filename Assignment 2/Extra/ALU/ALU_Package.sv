package ALU_Package;

typedef enum {Add,Sub,invert_A,reduction_OR_B} opcode_t;

class ALU_Constraints;

rand logic signed [3:0]a,b;
rand logic RESET;
rand opcode_t OPCODE;

constraint ALU_Cons {
                    RESET dist {0:=98 , 1:=2};

}

endclass

endpackage 