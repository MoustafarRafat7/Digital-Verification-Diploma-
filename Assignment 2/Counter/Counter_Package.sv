package Counter;

parameter WIDTH = 4;

class counter_constraints;

rand logic reset,load,enable,UP_DOWN;
rand logic [WIDTH-1:0] DATA_LOAD;

constraint counter_cons {
                        reset dist {0:=2 , 1:=98};
                        load dist  {0:=70 ,1:=30};
                        enable dist {0:=30 ,1:=70};
}
endclass
    
endpackage