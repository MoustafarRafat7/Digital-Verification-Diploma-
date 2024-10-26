package ALSU_sequence_item_pkg;
import uvm_pkg::*;
`include"uvm_macros.svh"

// Enums //
typedef enum {OR=0,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7}opcode_e;

// Parameters //
parameter MAXPOS=3;
parameter ZERO=0;
parameter MAXNEG=-4;

class ALSU_sequence_item extends uvm_sequence_item ;
`uvm_object_utils(ALSU_sequence_item)

rand bit signed [2:0] A, B;
rand bit rst;
rand opcode_e opcode;
rand bit cin, serial_in, red_op_A, red_op_B, bypass_A, bypass_B, direction;
logic signed [5:0] out;
logic [15:0] leds;

rand opcode_e arr [6];

function new (string name = "ALSU_sequence_item");
    super.new(name);
endfunction

// Constraints block //

constraint Reset_Cons {

    //Reset to be asserted with a low probability//
    rst dist {1:=1,0:=99}; 
}

constraint bypass_Cons{
    // bypass_A and bypass_B should be disabled most of the time //
    bypass_A dist {1:=4,0:=96};
    bypass_B dist {1:=4,0:=96};
}
constraint invalid_opcode_Cons {    
    // Invalid cases should occur less frequent than the valid cases //
    opcode dist {INVALID_6:/2,INVALID_7:/2,[0:5]:/96};
}

constraint ADD_MULT_opcode{
    // in case of addition or multiplication inputs (A, B) to take the values (MAXPOS, ZERO and MAXNEG) more often than others //
    if( opcode == ADD || opcode == MULT )
    {
    A dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    B dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    }
}

constraint OR_XOR_opcode_A{
     if(opcode == OR || opcode == XOR)
    {
        if (red_op_A) {
            A dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2} ;
            B == 0;
        }
        else if (red_op_B) {
            B dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2}  ;
            A == 0;
        }
    }
}


constraint arr_cons {
foreach (arr[i]) 
    foreach (arr[j]){ 
        if (i != j ){ 
            arr[i] != arr[j];
            arr[i] inside {[OR:ROTATE]};
        }
    }
}


function string  convert2string ();
return $sformatf("%s  A = 0%0b ,B = 0%0b ,cin = 0%0b ,serial_in = 0%0b ,red_op_A = 0%0b ,red_op_B = 0%0b ,opcode = 0%0b ,bypass_A = 0%0b ,bypass_B = 0%0b ,rst = 0%0b ,direction = 0%0b ,leds = 0%0b ,out = 0%0b",super.convert2string(),A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, rst, direction, leds, out);
endfunction

function string  convert2string_stimulus ();
return $sformatf("A = 0%0b ,B = 0%0b ,cin = 0%0b ,serial_in = 0%0b ,red_op_A = 0%0b ,red_op_B = 0%0b ,opcode = 0%0b ,bypass_A = 0%0b ,bypass_B = 0%0b ,rst = 0%0b ,direction = 0%0b",A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, rst, direction);
endfunction



endclass

class alsu_seq_item_valid extends ALSU_sequence_item ;
`uvm_object_utils(alsu_seq_item_valid)

function new( string name = "alsu_seq_item_valid");
    super.new(name);
endfunction
constraint invalid_opcode_Cons {    
    // valid cases only //
    opcode dist {INVALID_6:/0,INVALID_7:/0,[0:5]:/20};
}



endclass



endpackage