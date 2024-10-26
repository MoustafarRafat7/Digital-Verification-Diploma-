module FSM_SVA();

always_comb begin : 
    cs_onhot:assert($onhot(cs));
end

property current_state;

@(posedge clk )  ( (cs == IDLE) && ( $rose(get_data) ) ) |=> (cs == GEN_BLK_ADDR) ##64 (cs == WAITO) ;
endproperty

endmodule