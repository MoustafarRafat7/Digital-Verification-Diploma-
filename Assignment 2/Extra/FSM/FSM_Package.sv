package FSM;

typedef enum {IDLE,ZERO,ONE,STORE}state_e;

parameter T = 2;

class fsm_transaction;

rand logic x, rst;
logic y_exp ;
logic [9:0] user_count_exp;

constraint fsm {
            rst dist {0:=99 , 1:=1};
            x   dist {0:=67, 1:=33};
}
endclass

endpackage