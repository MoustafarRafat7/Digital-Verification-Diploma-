package FSM;

typedef enum {IDLE,ZERO,ONE,STORE}state_e;

parameter T = 2;

class fsm_transaction;

logic clk;
rand logic x, rst;
logic y_exp ;
logic [9:0] user_count_exp;

constraint fsm {
            rst dist {0:=99 , 1:=1};
            x   dist {0:=67, 1:=33};
}


covergroup cvr_gp @(posedge clk) ;

coverpoint x { bins x_trans = (0=>1=>0);
}

endgroup

function new;

     cvr_gp=new;    

endfunction

endclass

endpackage