module queue_ex();

int j ;
int q [$];

initial begin

    j=1;
    q={0,2,5};
    q.insert(1,j);
    $display("q after insert %0d in location 1  = %p",j,q);
    q.delete(1);
    $display("q after delete data in loaction 1  = %p",q);
    q.push_front(7);
    $display("q after insert 7 in location 0  = %p",q);
    q.push_back(9);
    $display("q after insert 9 in last location  = %p",q);
    j=q.pop_back;
    $display("q after pop_back = %p",q);
    $display("j = %0d",j);
    j=q.pop_front;
    $display("q after pop_front = %p",q);
    $display("j = %0d",j);
    q.reverse;
    $display("q after reverse = %p",q);
    q.sort;
    $display("q after sorting = %p",q);
    q.rsort;
    $display("q after reverse sort = %p",q);
    q.shuffle;
    $display("q after shuffle = %p",q);

end

endmodule