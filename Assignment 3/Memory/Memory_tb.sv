// Import Package //
import Memory_Package::*;

// Module Declaration //
module Memory_tb();

// Local Parameters //
localparam TESTS =100;

// Signals Declaration //
logic clk;
logic write;
logic read;
logic [7:0] data_in;
logic [15:0] address;
logic [8:0] data_out;

// Arrays //
logic [15:0] address_array [];
logic [7:0]data_to_write_array[];
logic [8:0]  data_read_expect_assoc [logic[15:0]];
logic [8:0] data_read_queue [$];

// Summary counters //
int Correct_count=0;
int Error_count=0;
int queue_size=0;
int n = 0;

// DUT Instantiation //
my_mem mem (.*);

// Clock Generation // 
always  begin
    clk=1'b0;
    #(T/2);
    clk=1'b1;
    #(T/2);
end

// Object Creation //
Memory_Transaction Mem=new();

initial begin

    // prepare the data & Address //
    stimulus_gen(Mem);

    // Stimulus Generation //
	// Memory_1 //
    for (int count1 = 0 ; count1 <TESTS ; count1++ ) begin
	@(negedge clk);
        write=1;
        read=0;
        data_in=data_to_write_array[count1];
        address=address_array[count1];
    end
	// Memory_2 //
	@(negedge clk);
        for (int count2 = TESTS-1 ; count2>=0 ; count2-- ) begin
            write=0;
            read=1;
            data_in=data_to_write_array[count2];
            address=address_array[count2];
            check_result();
	    data_read_queue.push_back(data_out);
    end
    // For 100% code coverage //
    write=1;
    read=0;
    #1;
//print out the data read stored in the data_read_queue //
queue_size=$size(data_read_queue);

 while (n<queue_size) begin
    $display("element no %0d : %p",n,data_read_queue.pop_front);
    n=n+1;
 end
$display("Testbench Summary : %0d Test Cases Passed , %0d Test Cases Failed ",Correct_count,Error_count);
$stop;
end


// Stimulus Generation stored in Arrays //
task stimulus_gen (Memory_Transaction Mem_t);

    address_array=new[TESTS];
    data_to_write_array=new[TESTS];
    for (int i  =0 ;i<TESTS ;i++ ) begin
    assert(Mem_t.randomize());
    address_array[i]=Mem_t.ADDRESS;
    data_to_write_array[i]=Mem.DATA_IN;
    end
    golden_model();

endtask


// Expected Values Generation //
task golden_model();
for ( int j =0 ;j<TESTS ;j++ ) begin
    data_read_expect_assoc[address_array[j]]={^data_to_write_array[j], data_to_write_array[j]};
end
endtask

// Response Checker //
task  check_result() ;
@(negedge clk);
if(data_read_expect_assoc[address] != data_out) begin

    Error_count=Error_count+1;
end
else begin
    Correct_count=Correct_count+1;
end

endtask


endmodule