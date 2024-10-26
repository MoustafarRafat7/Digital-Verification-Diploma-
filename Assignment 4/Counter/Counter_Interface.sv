interface Counter_Interface (clk);

parameter WIDTH = 4;

input clk;

bit rst_n;
bit load_n;
bit up_down;
bit ce;
bit [WIDTH-1:0] data_load;
bit [WIDTH-1:0] count_out;
bit max_count;
bit zero;

modport DUT  (input clk, rst_n, load_n, up_down, ce, data_load, output count_out, max_count, zero);
modport TEST (input clk, count_out, max_count, zero, output rst_n, load_n, up_down, ce, data_load);


endinterface