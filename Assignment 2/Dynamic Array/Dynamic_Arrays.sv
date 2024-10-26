module Dynamic_Arrays (
);

int dyn_arr1[], dyn_arr2[];
initial begin
   
    dyn_arr2 = '{9,1,8,3,4,4};
   
    dyn_arr1 = new[6];
    for ( int i = 0 ; i < $size(dyn_arr1) ; i=i+1  ) 
    begin
        dyn_arr1[i]=i;
    end
    $display("dyn_arr1: %p ",dyn_arr1);
    $display("Size of dyn_arr1 = %0d",dyn_arr1.size());
    dyn_arr1.delete();

    // Reverse the array dyn_arr2 //  shuffle the array dyn_arr2
    dyn_arr2.reverse();
    $display("dyn_arr2 Reversed: %p ",dyn_arr2);
    
    // Sort the array dyn_arr2 //
    dyn_arr2.sort();
    $display("dyn_arr2 Sorted: %p ",dyn_arr2);
    
    // Reverse sort the array dyn_arr2 //
    dyn_arr2.rsort();
    $display("dyn_arr2 Sort Reversed: %p ",dyn_arr2);
    
    //  shuffle the array dyn_arr2 //
    dyn_arr2.shuffle();
    $display("dyn_arr2 Shuffled: %p ",dyn_arr2);
    

end

    
endmodule