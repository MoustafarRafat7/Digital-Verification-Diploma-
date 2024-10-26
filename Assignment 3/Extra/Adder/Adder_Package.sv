package Adder_Package;

typedef enum  {MAXPOS=7,ZERO=0,MAXNEG=-8} value_e;
class Transaction ;
    rand bit RESET;
    rand logic  signed [3:0] A;	
    rand logic  signed [3:0] B;	

constraint Adder_Cons {
                      RESET dist {1:=2 ,0:=98};
                      A dist {MAXPOS:=50,MAXNEG:=50,ZERO:=50,[-7:-1]:=5,[1:6]:=5};
                      B dist {MAXPOS:=50,MAXNEG:=50,ZERO:=50,[-7:-1]:=5,[1:6]:=5};
}

covergroup Covgrp_A;
First_A : coverpoint A  {
                        bins data_0 = {ZERO};
                        bins data_max={MAXPOS};
                        bins data_min={MAXNEG};
                        bins data_default =default ;                        
}
Second_A: coverpoint A  {
                        bins data_0max = (ZERO => MAXPOS);
                        bins data_maxmin = (MAXPOS => MAXNEG);
                        bins data_minmax = (MAXNEG => MAXPOS);
                        
}
endgroup

covergroup Covgrp_B;
First_B : coverpoint B  {
                        bins data_0 = {ZERO};
                        bins data_max={MAXPOS};
                        bins data_min={MAXNEG};
                        bins data_default =default ;                        
}
Second_B: coverpoint B  {
                        bins data_0max = (ZERO => MAXPOS);
                        bins data_maxmin = (MAXPOS => MAXNEG);
                        bins data_minmax = (MAXNEG => MAXPOS);
                        
}
endgroup

function new();

    Covgrp_A = new();
    Covgrp_B = new();

endfunction

endclass

endpackage