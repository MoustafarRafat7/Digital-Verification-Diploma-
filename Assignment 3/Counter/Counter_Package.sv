package Counter;

parameter WIDTH = 4;
parameter MAXVAL=(2**WIDTH)-1; 
parameter ZERO =0;

class counter_constraints;

rand logic reset,load,enable,UP_DOWN;
rand logic [WIDTH-1:0] DATA_LOAD;
bit clk,RESET;
logic  [WIDTH-1:0]COUNT_OUT;

constraint counter_cons {
                        reset dist {0:=2 , 1:=98};
                        load dist  {0:=70 ,1:=30};
                        enable dist {0:=30 ,1:=70};
}

covergroup counter_coverage @(posedge clk);

load_coverpoint: coverpoint DATA_LOAD iff(load);
count_coverage1 : coverpoint COUNT_OUT iff(RESET && enable && UP_DOWN ) ;
count_coverage2 : coverpoint COUNT_OUT iff(RESET && enable && UP_DOWN )  {
                                                                bins maxvalue_2_zero = (15 => 0);

}
count_coverage3 : coverpoint COUNT_OUT iff(RESET && enable && !UP_DOWN ) ;
count_coverage4 : coverpoint COUNT_OUT iff(RESET && enable && !UP_DOWN )  {
                                                                bins zero_2_maxvalue = (0 => 15);

} 


endgroup

function new();
    
 counter_coverage =new;
    
endfunction


endclass
    
endpackage