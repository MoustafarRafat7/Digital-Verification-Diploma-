module Array ();

bit [11:0] my_array [4];
    initial begin
        my_array[0] = 12'h012; 
        my_array[1] = 12'h345; 
        my_array[2] = 12'h678;
        my_array[3] = 12'h9AB;
        $display("print out bits [5:4] of each 12-bit element Using a for loop");
        for(int i=0; i<$size(my_array);i=i+1)   
            begin
                $display("element no. %0d: %b ",i,my_array[i][5:4]);
            end
        $display("print out bits [5:4] of each 12-bit element Using a foreach loop");
        foreach(my_array[j])
            $display("element no.%0d: %b ",j,my_array[j][5:4]);
end

endmodule